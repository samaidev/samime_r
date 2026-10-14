#!/bin/bash
# install.sh — SamIME Linux 一键自举安装脚本
#
# 用法（复制到终端执行即可）：
#   curl -fsSL https://github.com/samaidev/samime_r/releases/latest/download/install.sh | sudo bash
#
# 行为：自动下载最新 SamIME-linux-x64.tar.gz（含 samime 引擎 + IBus 安装脚本），
#       解压到 /opt/samime，随后以预编译二进制模式完成 IBus 注册与激活。

set -euo pipefail

REPO="samaidev/samime_r"
BASE_URL="https://github.com/${REPO}/releases/latest/download"
TARBALL="SamIME-linux-x64.tar.gz"
DEST="/opt/samime"

log()  { echo -e "[SamIME] $*"; }
fail() { echo -e "[SamIME][错误] $*" >&2; exit 1; }

# ---------- 0. 前置检查 ----------
[ "$(id -u)" -eq 0 ] || fail "请用 root 运行：curl -fsSL <url>/install.sh | sudo bash"

ARCH="$(uname -m)"
[ "$ARCH" = "x86_64" ] || fail "仅支持 x86_64，当前架构: $ARCH（arm64 请从源码编译 samime）"

if command -v curl >/dev/null 2>&1; then
  FETCH="curl -fsSL --retry 3 -o"
elif command -v wget >/dev/null 2>&1; then
  FETCH="wget -q --tries=3 -O"
else
  fail "系统缺少 curl 或 wget，请先安装：apt-get install -y curl"
fi

TMP="$(mktemp -d /tmp/samime-install.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

# ---------- 1. 下载最新版 ----------
log "下载最新版 $TARBALL ..."
$FETCH "$TMP/$TARBALL" "$BASE_URL/$TARBALL" \
  || fail "下载失败，请检查网络后重试（$BASE_URL/$TARBALL）"
[ -s "$TMP/$TARBALL" ] || fail "下载的文件为空"

# ---------- 2. 解压 ----------
log "解压 ..."
tar -xzf "$TMP/$TARBALL" -C "$TMP" || fail "解压失败（文件损坏？）"
# 注：tar 包由 Windows 侧打出，可能不带执行位（MBA 实测踩坑）——
# 统一补 chmod，再用 -f 校验文件存在即可
chmod 755 "$TMP/samime/samime" 2>/dev/null || true
[ -f "$TMP/samime/samime" ] || fail "压缩包内容异常：缺少 samime 引擎"

# ---------- 3. 安装到 /opt/samime ----------
log "放置文件到 $DEST ..."
mkdir -p "$DEST"
install -m 755 "$TMP/samime/samime" "$DEST/samime"
install -m 644 "$TMP/samime/install.sh" "$DEST/install.sh" 2>/dev/null || cp -f "$TMP/samime/install.sh" "$DEST/install.sh"
[ -f "$TMP/samime/INSTALL.txt" ] && install -m 644 "$TMP/samime/INSTALL.txt" "$DEST/INSTALL.txt" 2>/dev/null || true

# ---------- 4. 调用 IBus 安装脚本（预编译二进制模式） ----------
log "执行 IBus 安装与注册 ..."
BIN="$DEST/samime" bash "$DEST/install.sh" --no-build </dev/null || true
# 注：install.sh 自带 root 检查 / 旧进程清理 / IBus 组件写入 / 输入源注册 / 引擎激活。

log "完成。引擎与安装脚本位于 $DEST/"
log "如输入法未自动激活，请在你的用户终端执行："
log "  ibus restart && sleep 18 && ibus engine samime"
log "然后按 Super+Space 切换到 SamIME 即可输入中文。"
