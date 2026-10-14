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
| 超低内存 | 搜狗式紧凑词库 + 内存映射，常驻 ~140MB（v3.0） |
| 零卡顿查找 | 全二分词典索引 + 60ms 有界纠错，长句输入 0-8ms 响应（v3.1） |

---

## 下载安装

### Windows（推荐：标准安装程序）

1. 下载安装包：[samime-setup-3.1.1.exe](https://github.com/samaidev/samime_r/releases/download/v3.1.1/samime-setup-3.1.1.exe)
   - 或访问 [Releases 页面](https://github.com/samaidev/samime_r/releases) 获取所有版本
2. 双击运行，按向导完成安装（自动注册 TSF、加入语言列表、创建开机自启与固化注册计划任务）
3. 安装完成后，按 **Win + Space** 切换到 Samime 即可使用

卸载：Windows「设置 → 应用 → 安装的应用」中卸载，或运行安装目录下的 `uninstall.exe`。

> 静默安装（无人值守）：`samime-setup-3.1.1.exe /S`
>
> 便携版（解压即用，v3.1.0）：[SamIME-v3.1.0-windows-x64.zip](https://github.com/samaidev/samime_r/releases/download/v3.1.0/SamIME-v3.1.0-windows-x64.zip)，解压后右键 `install.bat` 以管理员身份运行。

### v3.1.1 更新亮点：正式 Windows 安装程序

自 v3.1.1 起提供标准 NSIS 安装向导，一键完成全部安装：

- 简体中文安装界面，支持自定义安装目录与桌面快捷方式
- 全自动注册：regsvr32 + 独立注册工具，输入法安装后即被「添加并默认启用」
- 自动创建 `SamimeService`（登录自启引擎）与 `SamimeRegister`（开机固化重注册）计划任务，根治「重启后输入法消失」
- 完整卸载器：控制面板可卸载，注册表 / 语言列表 / 计划任务全量清理
- 支持 `/S` 静默安装，方便批量部署

引擎内核与 v3.1.0 相同（搜狗式全二分索引：长句 0ms、纠错有界 60ms、内存 ~140MB）。

### v3.1.0 更新亮点：搜狗式全二分索引，彻底消除打字卡顿

针对 v3.0 部分长句输入卡顿（如“天气不错”可达 0.7 秒）的深度优化：

| 指标 | v3.0 | v3.1 |
|------|------|------|
| 长句查找最坏延迟 | 542-904 ms | **0 ms**（精确命中路径） |
| 常规查询延迟 | 1-30 ms | **0-8 ms** |
| 错字容错延迟 | 144 ms 无上界 | **≤60 ms 有界保证** |
| 内存占用 | ~140 MB | ~140 MB（不变） |

技术要点（对齐搜狗全二分设计）：2-gram 语言模型组内改按词字节序重排，
查找从线性扫描降为 O(log k) 二分；切分引擎只解码候选头部条目；
纠错路径增加搜狗式门控与时间预算——精确命中零开销，错字容错最多 60ms。

### v3.0.0 更新亮点：搜狗式词库架构，内存降低 87%

| 指标 | v2.0 | v3.0 |
|------|------|------|
| 引擎常驻内存 | ~1.1 GB | **~140 MB** |
| 启动到可输入 | 数秒 | **即开即用** |
| 词库规模 | 101 万词条 | 101 万词条（不变） |
| 程序体积 | 78 MB | **69.5 MB** |

v3.0 对词库存储做了架构级重构（对齐搜狗输入法的紧凑二进制 + 内存映射方案）：
词库以自研 SIDB 格式离线打包，运行时通过 `MapViewOfFile` 只读映射、按需解码，
不物化任何对象；2-gram 语言模型同样二进制化（对标搜狗 `sgim_gd_bigram.bin`）。
输入法不再"吃内存"，老电脑也能流畅运行。

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
