# paper_html

把一篇学术论文，一键变成**通俗易懂的 HTML 解读**——给完全的外行也能看懂。

支持多种输入：**arXiv ID / arXiv 链接 / PDF 链接 / 本地 PDF / 甚至只给文章标题**（自动联网搜索定位）。

同时适配 **Claude Code** 和 **Codex** 两种 AI 编程工具。

解读的**语言跟随你的对话语言**：你用中文和它对话就生成中文；否则默认英文。

> English version: [README.en.md](README.en.md).
>
> 本 skill 由 Codex 和 Claude Code 辅助完成。

---

## 它能做什么

给它一篇论文，它会自动：

1. **下载并归档**：PDF、arXiv LaTeX 源码、论文里的原图，分文件夹放好。
2. **通读论文**：提炼出痛点、核心点子、方法、结果、局限。
3. **写成 HTML 解读**：用大白话 + 生活比喻 + 配图 + 结果表 + FAQ 讲清楚，自包含、离线可打开。

产出的目录长这样：

```
<论文名>/
├── pdf/                   论文原始 PDF
├── tex/                   arXiv LaTeX 源码（含原图）
└── html/
    ├── images/           原文图片
    └── 关键词-简称.html    通俗解读
```

HTML 文件名规则：`<3-6字领域关键词>-<模型/方法简称>.html`，例如 `潜空间推理-MCOUT.html`。

---

## 输入方式（任选其一）

| 你手上有什么 | 怎么给 |
|---|---|
| arXiv 编号 | `2508.12587` |
| arXiv 链接 | `https://arxiv.org/abs/2508.12587`（abs/pdf/html 都行） |
| 论文 PDF 链接 | `https://xxx.com/paper.pdf` |
| 本地 PDF 文件 | `/path/to/paper.pdf` |
| 只记得标题 | `Multimodal Chain of Continuous Thought`（会联网搜索并先和你确认） |

---

## 安装与使用

### 1. Claude Code

把本仓库放进 Claude Code 的 skills 目录（项目级或用户级均可）：

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
读一下这篇论文 https://arxiv.org/abs/2508.12587，写成易懂的中文网页
```

### 2. Codex

克隆仓库，并把命令文件装到 Codex 的 prompts 目录：

```bash
git clone https://github.com/feng1201/paper_html.git
export PAPER_HTML_DIR="$(pwd)/paper_html"          # 建议写进 ~/.zshrc / ~/.bashrc
cp paper_html/prompts/paper-html.md ~/.codex/prompts/paper-html.md
# 打开 ~/.codex/prompts/paper-html.md，把里面的 $PAPER_HTML_DIR 改成上面的实际路径
```

然后在 Codex 里：

```
/paper-html 2508.12587
```

### 3. 直接当脚本用（任何环境）

只想下载论文、自己写解读：

```bash
bash scripts/fetch_paper.sh 2508.12587 MCOUT_latent_reasoning ./papers
```

---

## 仓库结构

```
paper_html/
├── README.md                  中文说明（默认）
├── README.en.md               英文说明
├── SKILL.md                   Claude Code 入口（skill 定义）
├── prompts/
│   └── paper-html.md          Codex 入口（/paper-html 命令）
├── reference/
│   ├── workflow.md            核心流程（两个工具共用的唯一真源）
│   ├── writing-style.md       写作风格指南（怎么写得通俗）
│   └── template.html          HTML 模板（自带配色 CSS）
├── scripts/
│   └── fetch_paper.sh         下载脚本（PDF + 源码 + 图片）
└── examples/                  示例产出
```

两个入口（`SKILL.md` 与 `prompts/paper-html.md`）都只是薄壳，真正的方法写在 `reference/` 里，改一处两个工具同时生效。

---

## 示例

以论文 [MCOUT (arXiv:2508.12587)](https://arxiv.org/abs/2508.12587) 为例，产出一份带原图、比喻、结果表和 FAQ 的中文解读网页。见 `examples/`。

---

## 设计原则

- **给外行讲**：每个术语都配解释和比喻，公式翻译成人话。
- **诚实**：论文的局限和失败发现也讲清楚，并说明为什么有价值。
- **自包含**：图片、样式都内嵌，离线能打开，不依赖外部图床。
- **数字忠于原文**：所有数据以原始 PDF 为准。

---

## License

MIT
