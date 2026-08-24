#!/bin/bash
# install.sh — Samime 一键安装/升级脚本（Linux，IBus 模式）
#
# 用法：
#   curl -fsSL https://raw.githubusercontent.com/samaidev/samime_r/main/install.sh | sudo bash
#
# 脚本下载预编译二进制（无需 Go 工具链，无需 clone 源码），安装到 /usr/bin/samime，
# 注册 IBus 组件并提示如何切换引擎。
#
# 前置依赖：IBus 1.5+（Ubuntu/Debian: sudo apt install -y ibus）

set -euo pipefail

VERSION="2.0.2"
BINARY_URL="https://github.com/samaidev/samime_r/releases/download/v${VERSION}/samime-linux-amd64"
INSTALL_BIN="/usr/bin/samime"
WRAPPER_DIR="/usr/lib/samime"
WRAPPER="$WRAPPER_DIR/samime-ibus.sh"
OLD_WRAPPER="/usr/local/bin/samime-ibus.sh"
IBUS_COMP_DIR="/usr/share/ibus/component"
IBUS_XML="$IBUS_COMP_DIR/samime.xml"
LOG="/tmp/samime-ibus.log"
TMP_BIN="/tmp/samime-linux-amd64"

echo "=================================================="
echo " Samime ${VERSION} 一键安装（Linux/IBus）"
echo "=================================================="

# ---------- 0. 权限检查 ----------
if [ "$(id -u)" -ne 0 ]; then
  echo "[!] 请使用 sudo 运行："
  echo "    curl -fsSL https://raw.githubusercontent.com/samaidev/samime_r/main/install.sh | sudo bash"
  exit 1
fi

# ---------- 1. 检查 IBus ----------
if ! command -v ibus >/dev/null 2>&1; then
  echo "[!] 未找到 ibus。请先安装："
  echo "    sudo apt install -y ibus    # Ubuntu/Debian"
  exit 1
fi

# ---------- 2. 下载预编译二进制 ----------
echo "[1/5] 下载 samime-linux-amd64 ..."
# 用 curl -L 跟随 GitHub 重定向
if ! curl -fSL --retry 3 -o "$TMP_BIN" "$BINARY_URL"; then
  echo "[!] 下载失败。请检查网络或手动下载："
  echo "    $BINARY_URL"
  exit 1
fi
chmod +x "$TMP_BIN"
DOWNLOADED_SIZE=$(stat -c%s "$TMP_BIN" 2>/dev/null || stat -f%z "$TMP_BIN")
echo "[OK] 已下载 ${DOWNLOADED_SIZE} 字节"

# ---------- 3. 停掉旧进程 ----------
echo "[2/5] 停止旧 samime 进程..."
pkill -x samime 2>/dev/null || true
for p in $(pgrep -f "/usr/bin/samime" 2>/dev/null); do kill "$p" 2>/dev/null || true; done
for p in $(pgrep -f "samime -mode=service" 2>/dev/null); do kill "$p" 2>/dev/null || true; done
sleep 2

# ---------- 4. 安装二进制 + 包装脚本 ----------
echo "[3/5] 安装二进制与包装脚本..."
install -m 755 "$TMP_BIN" "$INSTALL_BIN"
rm -f "$TMP_BIN"

mkdir -p "$WRAPPER_DIR"
cat > "$WRAPPER" <<'IBUS_SH'
#!/bin/bash
export SAMIME_IBUS_LOG=/tmp/samime-ibus.log
exec /usr/bin/samime -mode=service --ibus >"$SAMIME_IBUS_LOG" 2>&1
IBUS_SH
chmod 755 "$WRAPPER"
rm -f "$OLD_WRAPPER"

# ---------- 5. IBus 组件 XML ----------
echo "[4/5] 写入 IBus 组件配置..."
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

ibus write-cache --system 2>/dev/null || true

# ---------- 6. 提示激活 ----------
echo "[5/5] 安装完成。"
echo ""
echo "============================================"
echo "  文件已全部安装到位："
echo "    二进制:  $INSTALL_BIN"
echo "    包装器:  $WRAPPER"
echo "    IBus:    $IBUS_XML"
echo "============================================"
echo ""
echo "  请在你的桌面用户终端（非 sudo）执行以下命令激活引擎："
echo ""
echo "    gsettings set org.freedesktop.ibus.general preload-engines \"['xkb:us::eng', 'samime']\""
echo "    ibus restart"
echo "    sleep 18    # 等待词典加载（约 5-18 秒）"
echo "    ibus engine samime"
echo ""
echo "  验证: ibus engine   (应显示 samime)"
echo "  切换: Super+Space"
echo "  日志: $LOG"
echo ""
echo "  如果 ibus engine samime 报错 'No engine'，等 5 秒后重试"
echo "  （引擎注册需要时间，首次启动词典加载约 5-18 秒）"
