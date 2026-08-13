# Samime 中文拼音输入法

<p align="center">
  <strong>SamAI Group 出品 · 免费无广告 · 简体中文拼音输入法</strong>
</p>

---

## 关于 Samime

**Samime** 是 [SamAI Group](https://samai.cc) 开发的跨平台中文拼音输入法，采用 Go 语言编写，覆盖 **Windows / Linux / macOS** 三大平台。

### 为什么选择 Samime？

- 🆓 **完全免费，永无广告** — 不收集任何用户数据，不推送任何广告
- 🇨🇳 **简体中文拼音输入** — 支持全拼、简拼、模糊音、整句输入
- ⚡ **极速响应** — Go 语言原生编译，启动快、占用低
- 🎨 **精美候选窗** — Direct2D 硬件加速渲染，支持翻页、拖拽
- 🔧 **智能标点** — 直接敲 , . ? ! 自动输出 ， 。 ？ ！
- ⌨️ **Shift 切换中英文** — 单独按 Shift 即可切换，不打断输入节奏
- 📚 **用户词典学习** — 自动记忆常用词，越用越顺手

### 主要特性

| 特性 | 说明 |
|------|------|
| 实时拼音显示 | 拼音字母带下划线实时显示在光标位置 |
| 智能候选排序 | 基于词频 + 用户习惯的候选词排序 |
| 整句输入 | 支持整句拼音切分，如 woaixuexi → 我爱学习 |
| 模糊音 | 支持 z/zh、s/sh、c/ch、n/l 等常见模糊音 |
| 中文标点 | 逗号/句号/问号/感叹号自动转中文标点 |
| 候选翻页 | 候选词超过 5 个时支持翻页，点击"更多"或上下箭头 |
| 用户词典 | 自动学习用户选词，提升输入效率 |

---

## 下载安装

### Windows

1. 下载最新版 samime-setup-x.x.x.exe（见下方 Releases）
2. **以管理员身份运行**安装包
3. 安装完成后，按 Win + Space 切换到 Samime 即可使用

### Linux（IBus）

```bash
curl -fsSL https://raw.githubusercontent.com/samaidev/samime_r/main/install.sh | bash
```

安装完成后，在系统设置中添加 Samime 输入源即可。

### macOS

macOS 版本正在开发中，敬请期待。

---

## 系统要求

- Windows 10/11 64 位
- Linux 支持 IBus 或 Fcitx5 的发行版（Ubuntu 20.04+、Debian 11+、Fedora 35+ 等）
- macOS 12 Monterey 或更高版本（即将支持）

---

## 关于 SamAI Group

SamAI Group 是一家专注于人工智能与中文自然语言处理的科技团队，使命是让中文输入更智能、更高效、更自然。Samime 是团队的旗舰产品，用 Go 语言编写，覆盖 Windows / macOS / Linux 三平台。

官网：https://samai.cc

---

## 反馈与支持

- 问题反馈：提交 Issue
- 官方网站：https://samai.cc

---

## License

Samime 安装包免费提供个人及商业使用。源代码为闭源项目，版权所有 SamAI Group。
