#!/bin/bash
# install.sh — Samime 一键安装/升级脚本（Linux，IBus 模式，用户级安装）
#
# 用法：
#   curl -fsSL https://raw.githubusercontent.com/samaidev/samime_r/main/install.sh | bash
#
# 特点：
#   - 无需 sudo（安装到 ~/.local/bin 和 ~/.local/share）
#   - 无需 Go 工具链（下载预编译二进制）
#   - 无需 clone 源码
#
# 前置依赖：IBus 1.5+（Ubuntu/Debian: sudo apt install -y ibus）

set -euo pipefail

VERSION="2.0.2"
BINARY_URL="https://github.com/samaidev/samime_r/releases/download/v${VERSION}/samime-linux-amd64"
LOG="/tmp/samime-ibus.log"
TMP_BIN="/tmp/samime-linux-amd64-$$"

# 用户级安装目录
LOCAL_BIN_DIR="$HOME/.local/bin"
LOCAL_SHARE_DIR="$HOME/.local/share/samime"
INSTALL_BIN="$LOCAL_BIN_DIR/samime"
WRAPPER="$LOCAL_SHARE_DIR/samime-ibus.sh"
IBUS_COMP_DIR="$HOME/.local/share/ibus/component"
IBUS_XML="$IBUS_COMP_DIR/samime.xml"

echo "=================================================="
echo " Samime ${VERSION} 一键安装（Linux/IBus，用户级）"
echo "=================================================="

# ---------- 1. 检查 IBus ----------
if ! command -v ibus >/dev/null 2>&1; then
  echo "[!] 未找到 ibus。请先安装："
  echo "    sudo apt install -y ibus    # Ubuntu/Debian"
  exit 1
fi

# ---------- 2. 下载预编译二进制 ----------
echo "[1/5] 下载 samime-linux-amd64 ..."
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
for p in $(pgrep -f "samime -mode=service" 2>/dev/null); do kill "$p" 2>/dev/null || true; done
sleep 2

# ---------- 4. 安装二进制 + 包装脚本 ----------
echo "[3/5] 安装二进制与包装脚本..."
mkdir -p "$LOCAL_BIN_DIR" "$LOCAL_SHARE_DIR"
mv -f "$TMP_BIN" "$INSTALL_BIN"
chmod 755 "$INSTALL_BIN"

cat > "$WRAPPER" <<'IBUS_SH'
#!/bin/bash
export SAMIME_IBUS_LOG=/tmp/samime-ibus.log
exec BINDIR/samime -mode=service --ibus >"$SAMIME_IBUS_LOG" 2>&1
IBUS_SH
# Replace BINDIR placeholder with actual path
sed -i "s|BINDIR|$LOCAL_BIN_DIR|g" "$WRAPPER"
chmod 755 "$WRAPPER"

# ---------- 5. IBus 组件 XML（用户级） ----------
echo "[4/5] 写入 IBus 组件配置..."
mkdir -p "$IBUS_COMP_DIR"
cat > "$IBUS_XML" <<XML
<?xml version="1.0" encoding="UTF-8"?>
<component>
    <name>org.freedesktop.IBus.Samime</name>
    <description>Samime Chinese Input Method (Go)</description>
    <exec>$WRAPPER</exec>
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

# 刷新 IBus 缓存（用户级）
ibus write-cache 2>/dev/null || true

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
echo "  现在执行以下命令激活引擎（无需 sudo）："
echo ""
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
