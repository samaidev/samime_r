# Samime - 轻量级中文拼音输入法

> Lightweight Chinese Pinyin Input Method for Windows & Linux

## 简介

Samime 是一个开源、轻量级的中文拼音输入法，支持 Windows (TSF) 和 Linux (IBus/Fcitx5) 双平台。

### 特性

- **实时拼音显示**：输入拼音时字母实时显示在光标处，带下划线标记
- **智能候选词**：基于词典 + bigram 模型 + 用户习惯学习的多维度候选排序
- **整句输入**：支持连续拼音输入，自动切分音节并匹配整句
- **模糊音/容错**：支持模糊音匹配和拼写错误容错
- **简拼/全拼混合**：支持首字母缩写（如"nh"→"你好"）和简拼全拼混合输入
- **末尾声母续拼**：输入到"nih"即可显示"你好"，无需输完整
- **上下文续接**：基于上次提交的词预测下一个词（如输入"今天天"后输入"q"→"气怎么样"）
- **用户词典学习**：选过的候选词下次自动提升排名
- **中文标点**：中文模式下直接输入逗号、句号、问号自动转换为中文标点
- **候选词翻页**：支持键盘上下箭头、鼠标点击"更多▼"翻页
- **候选窗拖拽**：鼠标拖拽移动候选窗口位置
- **Direct2D 渲染**：候选词窗口使用 Direct2D 硬件加速渲染

## 下载安装

### Windows

1. 下载安装包：[samime-setup-1.0.0.exe](https://github.com/samaidev/samime_r/releases/latest)
2. 以管理员身份运行 `samime-setup-1.0.0.exe`
3. 安装完成后，按 `Win + 空格` 切换到 Samime 输入法
4. 开始输入拼音即可使用

**系统要求**：Windows 10/11 64位

### Linux (一键安装)

```bash
curl -fsSL https://raw.githubusercontent.com/samaidev/samime_r/main/install.sh | bash
```

### 从源码构建

```bash
# 克隆仓库
git clone https://github.com/samaidev/samime_r.git
cd samime_r

# Windows (需要 Go + MinGW)
powershell -ExecutionPolicy Bypass -File install.ps1

# Linux (需要 Go + IBus)
sudo bash install.sh
```

## 使用方法

| 操作 | 功能 |
|------|------|
| 输入字母 | 实时显示拼音，候选词自动出现 |
| 空格 | 提交第一个候选词 |
| 1-9 | 选择对应候选词 |
| ↑/↓ 或点击"更多▼" | 翻页查看更多候选词 |
| 回车 | 提交当前拼音原文 |
| ESC | 清空当前输入 |
| 退格 | 删除最后一个字母 |
| `,` | 提交候选词 + 中文逗号 `，` |
| `.` | 提交候选词 + 中文句号 `。` |
| `?` | 提交候选词 + 中文问号 `？` |
| 鼠标拖拽候选窗 | 移动候选窗口位置 |

## 技术架构

- **Go 引擎**：拼音切分、词典查找、bigram 模型、用户词典持久化
- **Windows TSF**：Text Services Framework 接口，C++ 实现，Direct2D 渲染
- **Linux IBus/Fcitx5**：DBus 通信，Go 实现
- **词典格式**：自定义 trie 结构，支持前缀匹配和 O(1) 查找
- **用户词典**：BadgerDB 嵌入式数据库，时间衰减频次

## 项目结构

```
samime/
├── cmd/ime-cli/           # Go 引擎入口 (服务模式 + 托盘)
├── internal/
│   ├── engine/            # 拼音引擎 (搜索/排序/学习)
│   ├── dict/              # 词典 trie + 缓存
│   ├── pinyin/            # 拼音切分
│   ├── segmenter/         # 分词 + bigram
│   ├── winime/            # Windows TSF 实现 (C++)
│   │   └── cpp/           # TSF DLL 源码
│   ├── ibus/              # Linux IBus 实现
│   └── fcitx5/            # Linux Fcitx5 实现
├── packaging/windows/     # NSIS 安装包脚本
├── assets/icons/          # 图标资源
├── install.ps1            # Windows 一键安装
└── install.sh             # Linux 一键安装
```

## 开源协议

MIT License

## 致谢

- [Microsoft SampleIME](https://github.com/microsoft/Windows-classic-samples) - TSF 参考实现
- [weasel (RIME)](https://github.com/rime/weasel) - DirectWrite 测量参考
- 所有贡献者和用户反馈
