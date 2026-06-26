<div align="center">

# 📄 → 🌐 paper_html

**把一篇学术论文，一键变成给外行也能看懂的 HTML 解读**

一个同时适配 **Claude Code** 和 **Codex** 的 skill ——
输入 arXiv ID / 链接 / PDF / 甚至只给标题，自动下载、归档、并写成图文并茂的通俗解读网页。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Claude Code](https://img.shields.io/badge/Claude%20Code-skill-8A5CF6)
![Codex](https://img.shields.io/badge/Codex-prompt-10A37F)
![Lang](https://img.shields.io/badge/output-中文%20%7C%20English-orange)
[![Stars](https://img.shields.io/github/stars/feng1201/paper_html?style=flat)](https://github.com/feng1201/paper_html/stargazers)

**中文** · [English](README.en.md)

**📑 输出 HTML 示例如下：**

<img src="assets/demo.jpg" width="760" alt="paper_html 生成的解读网页示例">

<sub>↑ 以论文 MCOUT (arXiv:2508.12587) 为例自动生成的中文解读片段</sub>

</div>

---

## ✨ 它能做什么

给它一篇论文，它会自动：

1. **📥 下载并归档** —— PDF、arXiv LaTeX 源码、论文原图，分文件夹放好。
2. **📖 通读论文** —— 提炼出痛点、核心点子、方法、结果、局限。
3. **🌐 写成 HTML 解读** —— 用大白话 + 生活比喻 + 配图 + 结果表 + FAQ 讲清楚，**自包含、离线可打开**。

> 解读的**语言跟随你的对话语言**：你用中文和它对话就生成中文；否则默认英文。
>
> 本 skill 由 Codex 和 Claude Code 辅助完成。

---

## 🎯 支持的输入（任选其一）

| 你手上有什么 | 怎么给 |
|---|---|
| arXiv 编号 | `2508.12587` |
| arXiv 链接 | `https://arxiv.org/abs/2508.12587`（abs/pdf/html 都行） |
| 论文 PDF 链接 | `https://xxx.com/paper.pdf` |
| 本地 PDF 文件 | `/path/to/paper.pdf` |
| 只记得标题 | `Multimodal Chain of Continuous Thought`（会联网搜索并先和你确认） |

产出目录：

```
<论文名>/
├── pdf/                   论文原始 PDF
├── tex/                   arXiv LaTeX 源码（含原图）
└── html/
    ├── images/           原文图片
    └── 关键词-简称.html    通俗解读（如 潜空间推理-MCOUT.html）
```

---

## 🚀 安装与使用

<details open>
<summary><b>① Claude Code</b></summary>

```bash
git clone https://github.com/feng1201/paper_html.git
# 用户级（全局可用）：
ln -s "$(pwd)/paper_html" ~/.claude/skills/paper-html
# 或项目级：
ln -s "$(pwd)/paper_html" <你的项目>/.claude/skills/paper-html
```

然后在 Claude Code 里直接说，或用 skill：

```
/paper-html 2508.12587
读一下 https://arxiv.org/abs/2508.12587，写成易懂的中文网页
```
</details>

<details>
<summary><b>② Codex</b></summary>

```bash
git clone https://github.com/feng1201/paper_html.git
export PAPER_HTML_DIR="$(pwd)/paper_html"          # 建议写进 ~/.zshrc / ~/.bashrc
cp paper_html/prompts/paper-html.md ~/.codex/prompts/paper-html.md
# 打开 ~/.codex/prompts/paper-html.md，把 $PAPER_HTML_DIR 改成上面的实际路径
```

然后在 Codex 里：

```
/paper-html 2508.12587
```
</details>

<details>
<summary><b>③ 直接当脚本用（任何环境）</b></summary>

只想下载论文、自己写解读：

```bash
bash scripts/fetch_paper.sh 2508.12587 MCOUT_latent_reasoning ./papers
```
</details>

---

## 🧩 仓库结构

```
paper_html/
├── README.md / README.en.md   中文（默认）/ 英文说明
├── SKILL.md                   Claude Code 入口（skill 定义）
├── prompts/paper-html.md      Codex 入口（/paper-html 命令）
├── reference/
│   ├── workflow.md            核心流程（两个工具共用的唯一真源）
│   ├── writing-style.md       写作风格指南（怎么写得通俗）
│   └── template.html          HTML 模板（自带配色 CSS）
├── scripts/fetch_paper.sh     下载脚本（PDF + 源码 + 图片）
└── examples/                  示例产出（MCOUT 中文解读）
```

两个入口都只是薄壳，真正的方法写在 `reference/` 里 —— **改一处，两个工具同时生效。**

---

## 💡 设计原则

- **给外行讲** —— 每个术语都配解释和比喻，公式翻译成人话。
- **美观** —— 卡片式排版、配色协调、手机电脑自适应，读起来舒服不劝退。
- **诚实** —— 论文的局限和失败发现也讲清楚，并说明为什么有价值。
- **自包含** —— 图片、样式都内嵌，离线能打开，不依赖外部图床。
- **数字忠于原文** —— 所有数据以原始 PDF 为准。

---

## 📜 License

[MIT](LICENSE) © [feng1201](https://github.com/feng1201)
