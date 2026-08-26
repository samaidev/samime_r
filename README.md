# Samime 中文拼音输入法

<p align="center">
  <strong>SamAI Group 出品 · 免费无广告 · 简体中文拼音输入法</strong>
</p>

---

## 关于 Samime

Samime 是 [SamAI Group](https://samai.cc) 开发的跨平台中文拼音输入法，采用 Go 语言编写，覆盖 **Windows / Linux / macOS** 三大平台。

### 功能特性

- 🆓 **完全免费，永无广告** — 不收集任何用户数据，不推送任何广告
- 🇨🇳 **简体中文拼音输入** — 支持全拼、简拼、模糊音、整句输入
- ⚡ **极速响应** — Go 语言原生编译，启动快、占用低
- 🎨 **精美候选窗** — Direct2D 硬件加速渲染，支持翻页、拖拽
- 🔧 **智能标点** — 直接敲 `, . ? ; ' \` \` -` 等键自动输出对应中文标点
- ⌨️ **Shift 切换中英文** — 单独按 Shift 即可切换，已敲字母保留上屏
- 📚 **用户词典学习** — 自动记忆常用词，越用越顺手，重启后仍生效
- 🔍 **拼写容错** — 输入 `chognxin` 自动纠正为 `重新`，长句也支持

### 主要特性

| 特性 | 说明 |
|------|------|
| 实时拼音显示 | 拼音字母带下划线实时显示在光标位置 |
| 智能候选排序 | 基于词频 + 用户习惯的候选词排序 |
| 整句输入 | 支持整句拼音切分，如 `woaixuexi` → 我爱学习 |
| 简拼混合 | 输入 `nh` → 你好、`yij` → 已经、`guanf` → 官方 |
| 模糊音 | 支持 z/zh、s/sh、c/ch、n/l 等常见模糊音 |
| 中文标点 | ；：、""''【】《》——～ 等 14 种标点 |
| 候选翻页 | 候选词超过 5 个时支持翻页，上下箭头选择 |
| 用户词典 | 自动学习用户选词，最近使用的词优先排序 |

---

## 下载安装

### Windows

1. 下载最新版安装包：[samime-setup-2.0.2.exe](https://github.com/samaidev/samime_r/releases/download/v2.0.2/samime-setup-2.0.2.exe)
   - 或访问 [Releases 页面](https://github.com/samaidev/samime_r/releases) 获取所有版本
2. **以管理员身份运行**安装包
3. 安装完成后，按 **Win + Space** 切换到 Samime 即可使用

### Linux（IBus）

一键安装（下载预编译二进制，无需 Go，无需 sudo）：

```bash
curl -fsSL https://raw.githubusercontent.com/samaidev/samime_r/main/install.sh | bash
```

安装完成后执行（在桌面终端，非 sudo）：
```bash
ibus restart && sleep 18 && ibus engine samime
```

按 **Super+Space** 切换到 Samime 即可输入中文。

### macOS

macOS 版本正在开发中，敬请期待。

---

## 系统要求

- Windows 10/11 64 位
- Linux 支持 IBus 的发行版（Ubuntu 20.04+、Debian 11+、Fedora 35+ 等）
- macOS 12 Monterey 或更高版本（即将支持）

---

## 关于 SamAI Group

SamAI Group 是一家专注于人工智能与中文自然语言处理的科技团队，使命是让中文输入更智能、更高效、更自然。Samime 是团队的旗舰产品，用 Go 语言编写，覆盖 Windows / macOS / Linux 三平台。

官网：https://samai.cc

---

## 反馈与支持

- 问题反馈：提交 [Issue](https://github.com/samaidev/samime_r/issues)
- 官方网站：https://samai.cc

---

## License

Samime 安装包免费提供个人及商业使用。源代码为闭源项目，版权所有 SamAI Group。
