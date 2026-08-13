#!/bin/bash
# install.sh — Samime 一键安装/升级脚本（Linux，IBus 模式）
#
# 作用：
#   1. 编译（或复制预编译二进制）Samime Go 引擎
#   2. 停掉旧 samime 进程（避免覆盖时“文本文件忙”）
#   3. 安装二进制 + IBus 包装脚本 + IBus 组件 XML
#   4. 注册输入源、重启 IBus 并切换引擎
#   5. 等待引擎加载完成后验证（新版词典加载约 18s，故需等待）
#
# 用法：
#   ./install.sh                 # 从仓库源码编译并安装
#   BIN=/path/to/samime ./install.sh   # 使用指定的预编译二进制
#   ./install.sh --no-build      # 跳过编译（配合 BIN= 使用）
#
# 踩坑固化（来自真实调试经验）：
#   * IBus 组件 XML 的 <exec> 必须含 --ibus，否则引擎不进 D-Bus 模式、打不出中文
#   * <language> 用 zho（不是 zh_CN）
#   * 覆盖运行中二进制会“文本文件忙”，必须先 pkill
#   * 新版本词典加载慢（~18s），切换引擎前必须等待，否则超时返回 xkb:us::eng
#   * 已废弃 Python 桥接（IBus 1.5 GI 绑定下 Factory 注册死锁）

set -euo pipefail

BIN="${BIN:-}"
NO_BUILD=0
for a in "$@"; do
  case "$a" in
    --no-build) NO_BUILD=1 ;;
    -h|--help) sed -n '2,30p' "$0"; exit 0 ;;
  esac
done

ROOT="$(cd "$(dirname "$0")" && pwd)"
INSTALL_BIN="/usr/bin/samime"
# 与 .deb/.rpm 保持一致：包装脚本放 /usr/lib/samime/，
# 不用 /usr/local（Debian Policy 9.1.2 保留给本地管理员）
WRAPPER_DIR="/usr/lib/samime"
WRAPPER="$WRAPPER_DIR/samime-ibus.sh"
OLD_WRAPPER="/usr/local/bin/samime-ibus.sh"
IBUS_COMP_DIR="/usr/share/ibus/component"
IBUS_XML="$IBUS_COMP_DIR/samime.xml"
LOG="/tmp/samime-ibus.log"

echo "=================================================="
echo " Samime 一键安装/升级"
echo "=================================================="

# ---------- 0. 权限检查 ----------
if [ "$(id -u)" -ne 0 ]; then
  echo "[!] 请使用 sudo 运行：sudo $0"
  exit 1
fi

# ---------- 1. 准备二进制 ----------
if [ "$NO_BUILD" -eq 0 ]; then
  if [ -z "$BIN" ]; then
    echo "[1/6] 编译 Samime 引擎..."
    if ! command -v go >/dev/null 2>&1; then
      echo "[!] 未找到 go，请先安装 Go 1.22+"
      exit 1
    fi
    BIN="$ROOT/_build/samime"
    mkdir -p "$ROOT/_build"
    go build -o "$BIN" ./cmd/ime-cli
    echo "[OK] 已编译: $BIN"
  fi
else
  if [ -z "$BIN" ]; then
    echo "[!] --no-build 需要配合 BIN=/path/to/samime"
    exit 1
  fi
fi

if [ ! -x "$BIN" ]; then
  echo "[!] 二进制不可用: $BIN"
  exit 1
fi

# ---------- 2. 停掉旧进程（关键：避免文本文件忙） ----------
echo "[2/6] 停止旧 samime 进程..."
pkill -x samime 2>/dev/null || true
# 兜底：精确匹配常见路径
for p in $(pgrep -f "/usr/bin/samime" 2>/dev/null); do kill "$p" 2>/dev/null || true; done
for p in $(pgrep -f "samime -mode=service" 2>/dev/null); do kill "$p" 2>/dev/null || true; done
sleep 2

# ---------- 3. 安装二进制 + 包装脚本 ----------
echo "[3/6] 安装二进制与包装脚本..."
install -m 755 "$BIN" "$INSTALL_BIN"

mkdir -p "$WRAPPER_DIR"
cat > "$WRAPPER" <<'IBUS_SH'
#!/bin/bash
export SAMIME_IBUS_LOG=/tmp/samime-ibus.log
exec /usr/bin/samime -mode=service --ibus >"$SAMIME_IBUS_LOG" 2>&1
IBUS_SH
chmod 755 "$WRAPPER"

# 清理旧版本残留在 /usr/local/bin 的脚本，避免两份并存
rm -f "$OLD_WRAPPER"

# ---------- 4. IBus 组件 XML ----------
echo "[4/6] 写入 IBus 组件配置..."
mkdir -p "$IBUS_COMP_DIR"
cat > "$IBUS_XML" <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<component>
    <name>org.freedesktop.IBus.Samime</name>
    <description>Samime Chinese Input Method (Go)</description>
    <exec>/usr/lib/samime/samime-ibus.sh</exec>
    <version>1.0.0</version>
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

# ---------- 5. 注册输入源并重启 IBus ----------
echo "[5/6] 注册输入源、重启 IBus..."
# 找到当前登录用户（用于设置用户级 gsettings / 重启 IBus）
# 注意：不要用 logname（在 sudo 下可能挂起）；优先 $SUDO_USER，其次 who。
REAL_USER="${SUDO_USER:-}"
if [ -z "$REAL_USER" ]; then
  REAL_USER="$(who 2>/dev/null | awk '{print $1}' | grep -v root | head -1)"
fi

INTERACTIVE=0
[ -t 1 ] && INTERACTIVE=1

if [ "$INTERACTIVE" -eq 1 ]; then
  # 交互环境：尝试 best-effort 自动激活（ibus 依赖桌面会话 DBUS，
  # 在 sudo/root 上下文里 runuser 调用会挂起，故仅 best-effort 并提示手动）。
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
  # 注意：ibus restart 在 runuser 子进程内会卡住，故用 nohup 脱离，
  # 若失败不影响安装结果，末尾会提示手动激活。
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
