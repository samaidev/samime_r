#!/bin/bash
# install.sh — Samime 一键安装/升级脚本（Linux，IBus 模式）
#
# 用法：
#   curl -fsSL https://raw.githubusercontent.com/samaidev/samime_r/main/install.sh | sudo bash
#   # 或者从源码目录运行：
#   sudo ./install.sh
#
# 脚本会：
#   1. 如果当前目录没有 samime 源码，自动 git clone 到 /tmp/samime-src
#   2. 编译 Go 引擎（需要 go 1.22+）
#   3. 安装二进制 + IBus 包装脚本 + IBus 组件 XML
#   4. 注册输入源、重启 IBus 并切换引擎

set -euo pipefail

REPO_URL="https://github.com/samaidev/samime.git"
INSTALL_BIN="/usr/bin/samime"
WRAPPER_DIR="/usr/lib/samime"
WRAPPER="$WRAPPER_DIR/samime-ibus.sh"
OLD_WRAPPER="/usr/local/bin/samime-ibus.sh"
IBUS_COMP_DIR="/usr/share/ibus/component"
IBUS_XML="$IBUS_COMP_DIR/samime.xml"
LOG="/tmp/samime-ibus.log"

# Determine ROOT: if running from a samime source checkout (has cmd/ dir), use CWD.
# Otherwise (e.g. curl|bash), clone to /tmp/samime-src.
SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
if [ -f "$SCRIPT_DIR/cmd/ime-cli/main.go" ] && [ -f "$SCRIPT_DIR/go.mod" ]; then
  ROOT="$SCRIPT_DIR"
else
  # curl|bash mode: clone source
  ROOT="/tmp/samime-src"
  if [ ! -d "$ROOT/.git" ]; then
    echo "[*] 当前目录无 samime 源码，clone 到 $ROOT ..."
    rm -rf "$ROOT"
    git clone --depth=1 "$REPO_URL" "$ROOT"
  else
    echo "[*] 更新已有源码 $ROOT ..."
    (cd "$ROOT" && git pull --ff-only 2>/dev/null || true)
  fi
fi

echo "=================================================="
echo " Samime 一键安装/升级"
echo " 源码目录: $ROOT"
echo "=================================================="

# ---------- 0. 权限检查 ----------
if [ "$(id -u)" -ne 0 ]; then
  echo "[!] 请使用 sudo 运行：sudo bash install.sh"
  echo "    或：curl -fsSL https://raw.githubusercontent.com/samaidev/samime_r/main/install.sh | sudo bash"
  exit 1
fi

# ---------- 1. 检查 Go 工具链 ----------
if ! command -v go >/dev/null 2>&1; then
  echo "[!] 未找到 go。请先安装 Go 1.22+："
  echo "    sudo apt install -y golang-go    # Ubuntu/Debian"
  echo "    # 或从 https://go.dev/dl/ 下载"
  exit 1
fi
GO_VERSION="$(go version 2>/dev/null | awk '{print $3}')"
echo "[*] Go: $GO_VERSION"

# ---------- 2. 编译 ----------
echo "[1/6] 编译 Samime 引擎..."
BIN="$ROOT/_build/samime"
mkdir -p "$ROOT/_build"
( cd "$ROOT" && go build -o "$BIN" ./cmd/ime-cli )
if [ ! -x "$BIN" ]; then
  echo "[!] 编译失败"
  exit 1
fi
echo "[OK] 已编译: $BIN"

# ---------- 3. 停掉旧进程（避免文本文件忙） ----------
echo "[2/6] 停止旧 samime 进程..."
pkill -x samime 2>/dev/null || true
for p in $(pgrep -f "/usr/bin/samime" 2>/dev/null); do kill "$p" 2>/dev/null || true; done
for p in $(pgrep -f "samime -mode=service" 2>/dev/null); do kill "$p" 2>/dev/null || true; done
sleep 2

# ---------- 4. 安装二进制 + 包装脚本 ----------
echo "[3/6] 安装二进制与包装脚本..."
install -m 755 "$BIN" "$INSTALL_BIN"

mkdir -p "$WRAPPER_DIR"
cat > "$WRAPPER" <<'IBUS_SH'
#!/bin/bash
export SAMIME_IBUS_LOG=/tmp/samime-ibus.log
exec /usr/bin/samime -mode=service --ibus >"$SAMIME_IBUS_LOG" 2>&1
IBUS_SH
chmod 755 "$WRAPPER"

# 清理旧版本残留在 /usr/local/bin 的脚本
rm -f "$OLD_WRAPPER"

# ---------- 5. IBus 组件 XML ----------
echo "[4/6] 写入 IBus 组件配置..."
mkdir -p "$IBUS_COMP_DIR"
cat > "$IBUS_XML" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<component>
    <name>org.freedesktop.IBus.Samime</name>
    <description>Samime Chinese Input Method (Go)</description>
    <exec>/usr/lib/samime/samime-ibus.sh</exec>
    <version>2.0.2</version>
    <author>samime</author>
    <license>MIT</license>
    <homepage>https://github.com/samaidev/samime</homepage>
    <engines>
        <engine>
            <name>samime</name>
            <longname>Samime Pinyin</longname>
            <description>Samime Chinese Input Method (Go)</description>
            <language>zho</language>
            <license>MIT</license>
            <author>samime</author>
            <icon>samime</icon>
            <layout>us</layout>
        </engine>
    </engines>
</component>
XML

# 刷新 IBus 缓存
ibus write-cache --system 2>/dev/null || true

# ---------- 6. 注册输入源并重启 IBus ----------
echo "[5/6] 注册输入源、重启 IBus..."
REAL_USER="${SUDO_USER:-}"
if [ -z "$REAL_USER" ]; then
  REAL_USER="$(who 2>/dev/null | awk '{print $1}' | grep -v root | head -1)"
fi

INTERACTIVE=0
[ -t 1 ] && INTERACTIVE=1

if [ "$INTERACTIVE" -eq 1 ]; then
  if [ -n "$REAL_USER" ]; then
    UID_="$(id -u "$REAL_USER" 2>/dev/null)"
    XDG="/run/user/$UID_"
    if [ -d "$XDG" ]; then
      runuser -u "$REAL_USER" -- \
        gsettings set org.freedesktop.ibus.general preload-engines \
        "['xkb:us::eng', 'samime']" 2>/dev/null || true
    fi
  fi

  echo "      正在尝试重启并切换 IBus 引擎（best-effort）..."
  if [ -n "$REAL_USER" ] && [ -n "${XDG:-}" ]; then
    timeout 30 runuser -u "$REAL_USER" -- bash -c \
      "nohup ibus restart </dev/null >/dev/null 2>&1 &" 2>/dev/null || true
  fi
  sleep 18
  echo "[6/6] 切换引擎并验证..."
  CURRENT="unknown"
  if [ -n "$REAL_USER" ] && [ -n "${XDG:-}" ]; then
    timeout 15 runuser -u "$REAL_USER" -- bash -c "nohup ibus engine samime </dev/null >/dev/null 2>&1 &" 2>/dev/null || true
    sleep 3
    CURRENT="$(timeout 15 runuser -u "$REAL_USER" -- bash -c "ibus engine </dev/null" 2>/dev/null || echo unknown)"
  fi

  if [ "$CURRENT" = "samime" ]; then
    echo ""
    echo "============================================"
    echo "  安装成功！Samime 已启用 (ibus engine = samime)"
    echo "============================================"
    echo "  按 Super+Space 切换到 Samime 即可输入中文。"
    echo "  引擎日志: $LOG"
  else
    echo ""
    echo "============================================"
    echo "  文件已安装到位，但引擎未能在脚本内自动切换"
    echo "  （ibus 依赖桌面会话，需在你的用户终端执行）："
    echo "============================================"
    echo "    ibus restart && sleep 18 && ibus engine samime"
    echo "  验证: ibus engine   (应显示 samime)"
    echo "  引擎日志: $LOG"
  fi
else
  echo "[5/6] 非交互环境：跳过 ibus 重启/切换（避免挂起）"
  echo "[6/6] 文件已全部安装到位。"
  echo ""
  echo "============================================"
  echo "  安装完成（文件已就位），请手动激活引擎："
  echo "============================================"
  echo "  1) ibus restart"
  echo "  2) sleep 18"
  echo "  3) ibus engine samime"
  echo "  验证: ibus engine   (应显示 samime)"
  echo "  引擎日志: $LOG"
fi
