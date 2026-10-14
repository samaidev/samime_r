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
| 🎨 精美候选窗 | Windows 端 Direct2D 硬件加速渲染，支持翻页 |
| 🔤 中英切换 | 单击 Shift 即时切换，已敲字母保留上屏 |
| 🈶 中文标点 | 直接输入 `，。？！；：""''【】《》` 等中文标点 |
| 📚 用户词典 | 自动记忆选词习惯，越用越顺手 |

---

## 下载安装

> 稳定下载链接（始终指向最新版本）：
> [Windows 安装程序](https://github.com/samaidev/samime_r/releases/latest/download/SamIME-windows-x64-setup.exe) ·
> [Windows 便携版](https://github.com/samaidev/samime_r/releases/latest/download/SamIME-windows-x64.zip) ·
> [Linux 一键安装包](https://github.com/samaidev/samime_r/releases/latest/download/SamIME-linux-x64.tar.gz)

### Windows 10 / 11（x64）

1. 下载 **安装程序** `SamIME-windows-x64-setup.exe`，双击运行
2. 按向导完成安装（可自定义安装目录、创建桌面快捷方式）
3. 安装完成后 SamIME 自动就绪：按 **Win + Space** 切换到 SamIME 即可输入中文

安装器自动完成 TSF 输入法注册、语言列表添加、开机自启与注册固化，无需任何手动配置。

- 静默安装（无人值守部署）：`SamIME-windows-x64-setup.exe /S`
- 便携版：下载 `SamIME-windows-x64.zip` 解压，右键以管理员身份运行 `install.bat`
- 卸载：Windows「设置 → 应用」中卸载，或运行安装目录下 `uninstall.exe`

### Linux / Ubuntu（x64）

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
| v3.2.2 | 2026-10-14 | [安装程序](https://github.com/samaidev/samime_r/releases/download/v3.2.2/SamIME-windows-x64-setup.exe) · [便携版](https://github.com/samaidev/samime_r/releases/download/v3.2.2/SamIME-windows-x64.zip) · [Linux](https://github.com/samaidev/samime_r/releases/download/v3.2.2/SamIME-linux-x64.tar.gz) | 最新版本 |
| v3.2.1 | 2026-10-14 | [安装程序](https://github.com/samaidev/samime_r/releases/download/v3.2.1/SamIME-windows-x64-setup.exe) · [便携版](https://github.com/samaidev/samime_r/releases/download/v3.2.1/SamIME-windows-x64.zip) · [Linux](https://github.com/samaidev/samime_r/releases/download/v3.2.1/SamIME-linux-x64.tar.gz) | 中文标点补齐 |
| v3.2.0 | 2026-10-14 | [安装程序](https://github.com/samaidev/samime_r/releases/download/v3.2.0/SamIME-windows-x64-setup.exe) · [便携版](https://github.com/samaidev/samime_r/releases/download/v3.2.0/SamIME-windows-x64.zip) · [Linux](https://github.com/samaidev/samime_r/releases/download/v3.2.0/SamIME-linux-x64.tar.gz) | Windows 安装向导 + Linux 一键安装包 |
| v3.1.1 | 2026-10-14 | [samime-setup-3.1.1.exe](https://github.com/samaidev/samime_r/releases/download/v3.1.1/samime-setup-3.1.1.exe) | 正式 Windows 安装程序（NSIS） |

> 本发布仓仅保留最近 3 个版本，更早版本已归档清理。

## 系统要求

| 平台 | 要求 |
|------|------|
| Windows | Windows 10 / 11，64 位 |
| Linux | x86_64，IBus 1.5+（Ubuntu 20.04+） |

## 关于 SamAI Group

Samime 由 [SamAI Group](https://samai.cc) 开发与维护。产品问题反馈请通过 [SamAI Group](https://samai.cc) 官方渠道联系。
