# Samime 中文拼音输入法

<p align="center">
  <strong>SamAI Group 出品 · 免费无广告 · 简体中文拼音输入</strong>
</p>

---

## 简介

Samime 是 SamAI Group 开发的免费中文拼音输入法，采用 Go 语言引擎与各平台原生输入框架（Windows TSF / Linux IBus）深度集成，单文件分发、开箱即用。全拼、简拼、整句、模糊音、智能纠错一站齐全，轻快流畅，永不打扰。

## 功能特性

| 特性 | 说明 |
|------|------|
| 🆓 完全免费 | 无广告、不收集用户数据 |
| ⌨️ 全拼 / 简拼 | `nihao` → 你好，`nh` → 你好，简拼全拼混合输入 |
| 📝 整句输入 | `woaixuexi` → 我爱学习，长句智能切分 |
| 🎯 智能纠错 | `chognxin` → 重新，按键顺序错误自动纠正 |
| 🗣️ 模糊音 | z/zh、s/sh、c/ch、n/l 等常见模糊音 |
| ⚡ 极速响应 | 搜狗式全二分词典索引，常规按键 0-8ms |
| 🪶 低占用 | mmap 零拷贝词库加载，常驻内存约 140MB |
| 🏆 搜狗式选词 | 搜狗官方词库热度 + 全网语料真实词频 + 现代汉语字频三源融合，候选排序对标搜狗（v3.3） |
| 🎙️ 离线语音输入 | `Ctrl+Shift+V` 说话即上屏（v3.4+），SenseVoice 离线模型，中/英混说、数字直出、自动标点，**录音不出本机** |
| 🎨 精美候选窗 | Windows 端 Direct2D 硬件加速渲染，支持翻页 |
| 🔤 中英切换 | 单击 Shift 即时切换，已敲字母保留上屏 |
| 🈶 中文标点 | 直接输入 `，。？！；：""''【】《》` 等中文标点 |
| 📚 用户词典 | 自动记忆选词习惯，越用越顺手 |

---

## 下载安装

> 稳定下载链接（始终指向最新版本）：
> [Windows 安装程序](https://github.com/samaidev/samime_r/releases/latest/download/SamIME-windows-x64-setup.exe) ·
> [Windows 便携版](https://github.com/samaidev/samime_r/releases/latest/download/SamIME-windows-x64.zip) ·
> [Linux 一键安装包](https://github.com/samaidev/samime_r/releases/latest/download/SamIME-linux-x64.tar.gz) ·
> [Linux 安装脚本](https://github.com/samaidev/samime_r/releases/latest/download/install.sh)

### Windows 10 / 11（x64）

1. 下载 **安装程序** `SamIME-windows-x64-setup.exe`，双击运行
2. 按向导完成安装（可自定义安装目录、创建桌面快捷方式）
3. 安装完成后 SamIME 自动就绪：按 **Win + Space** 切换到 SamIME 即可输入中文

安装器自动完成 TSF 输入法注册、语言列表添加、开机自启与注册固化，无需任何手动配置。

- 静默安装（无人值守部署）：`SamIME-windows-x64-setup.exe /S`
- 语音开关：任务栏托盘图标右键 → 「语音输入 / 关闭语音」（v3.4.1+，开启后前台自动持续听写）

#### 离线语音输入（可选，v3.4+）

安装器已内置语音识别运行库；语音模型（SenseVoice-small int8，约 227MB）按需安装：

1. 下载 [SamIME-voice-zh-1.0.zip](https://github.com/samaidev/samime_r/releases/latest/download/SamIME-voice-zh-1.0.zip) 并解压
2. 双击运行包内 `install_voice.bat`（安装到 `%LOCALAPPDATA%\SamIME\voice`）
3. 中文模式下按 **Ctrl+Shift+V** 开始说话，停顿约 2 秒自动上屏；`Esc` 取消

不装语音包完全不影响打字功能（按热键会提示「语音包未安装」）。识别**完全离线**，音频不经过任何服务器。

- 便携版：下载 `SamIME-windows-x64.zip` 解压，右键以管理员身份运行 `install.bat`
- 卸载：Windows「设置 → 应用」中卸载，或运行安装目录下 `uninstall.exe`

### Linux / Ubuntu（x64）

**方式一（推荐）：curl 一键安装**

```bash
curl -fsSL https://github.com/samaidev/samime_r/releases/latest/download/install.sh | sudo bash
```

脚本自动下载最新版 SamIME-linux-x64.tar.gz，安装到 /opt/samime 并完成 IBus 注册激活。

**方式二：手动下载安装包**

1. 下载 **一键安装包** [SamIME-linux-x64.tar.gz](https://github.com/samaidev/samime_r/releases/latest/download/SamIME-linux-x64.tar.gz)（内含 samime 引擎 + install.sh 安装脚本）
2. 解压后在所在目录执行：

```bash
sudo BIN=$(pwd)/samime bash install.sh --no-build
```

3. 若提示需手动激活（SSH/非图形环境），执行：

```bash
ibus restart && sleep 18 && ibus engine samime
```

- 切换输入法：**Super + Space**
- 引擎日志：`/tmp/samime-ibus.log`
- 升级：下载新版本安装包覆盖执行即可
- 卸载：`sudo pkill -x samime; sudo rm -f /usr/bin/samime /usr/local/bin/samime-ibus.sh /usr/share/ibus/component/samime.xml && ibus restart`

---

## 使用说明

| 操作 | 方式 |
|------|------|
| 切换到 SamIME | Windows：`Win + Space`；Linux：`Super + Space` |
| 中英文切换 | 单击 `Shift` |
| 中文标点 | 直接按键：`,` → `，`、`.` → `。`、`?` → `？` 等 |
| 候选翻页 | `PageUp` / `PageDown` 或 `-` / `=` |
| 选词 | 数字键 `1-9` 或空格选第一候选 |
| 回车 | 上屏原始拼音字母 |

## 发布版本

| 版本 | 发布日期 | 下载 | 说明 |
|------|----------|------|------|
| v3.4.4 | 2026-10-15 | [安装程序](https://github.com/samaidev/samime_r/releases/download/v3.4.4/SamIME-windows-x64-setup.exe) · [便携版](https://github.com/samaidev/samime_r/releases/download/v3.4.4/SamIME-windows-x64.zip) · [Linux](https://github.com/samaidev/samime_r/releases/download/v3.4.4/SamIME-linux-x64.tar.gz) · [install.sh](https://github.com/samaidev/samime_r/releases/download/v3.4.4/install.sh) | 联想行为修正：空格/回车上屏即结束联想，不再弹联想栏 |
| v3.4.3 | 2026-10-15 | [安装程序](https://github.com/samaidev/samime_r/releases/download/v3.4.3/SamIME-windows-x64-setup.exe) · [便携版](https://github.com/samaidev/samime_r/releases/download/v3.4.3/SamIME-windows-x64.zip) · [Linux](https://github.com/samaidev/samime_r/releases/download/v3.4.3/SamIME-linux-x64.tar.gz) · [install.sh](https://github.com/samaidev/samime_r/releases/download/v3.4.3/install.sh) | 性能优化：容错打字卡顿（70-107ms→30ms 内）+ 首启动空窗（管道 1s 就绪） |
| v3.4.2 | 2026-10-15 | [安装程序](https://github.com/samaidev/samime_r/releases/download/v3.4.2/SamIME-windows-x64-setup.exe) · [便携版](https://github.com/samaidev/samime_r/releases/download/v3.4.2/SamIME-windows-x64.zip) · [Linux](https://github.com/samaidev/samime_r/releases/download/v3.4.2/SamIME-linux-x64.tar.gz) · [install.sh](https://github.com/samaidev/samime_r/releases/download/v3.4.2/install.sh) | 联想无限续链修复（空格结束联想） |

> 本发布仓仅保留最近 3 个版本，更早版本已归档清理。

## 系统要求

| 平台 | 要求 |
|------|------|
| Windows | Windows 10 / 11，64 位 |
| Linux | x86_64，IBus 1.5+（Ubuntu 20.04+） |

## 关于 SamAI Group

Samime 由 [SamAI Group](https://samai.cc) 开发与维护。产品问题反馈请通过 [SamAI Group](https://samai.cc) 官方渠道联系。
