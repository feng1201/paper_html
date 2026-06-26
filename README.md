# paper_html

Turn any academic paper into an **easy-to-understand HTML explainer** — readable by a complete outsider.

Accepts many input forms: **arXiv ID / arXiv URL / PDF URL / local PDF / or just a paper title** (auto web-search to locate it).

Works with both **Claude Code** and **Codex**.

The explainer's **language follows your conversation language**: if you talk to the agent in Chinese it produces Chinese; otherwise it defaults to English.

> 中文说明见 [README.zh-CN.md](README.zh-CN.md)。
>
> This skill was built with the help of Codex and Claude Code.

---

## What it does

Give it a paper, and it automatically:

1. **Downloads and archives**: the PDF, the arXiv LaTeX source, and the paper's original figures — sorted into folders.
2. **Reads the paper**: extracts the pain point, core idea, method, results, and limitations.
3. **Writes an HTML explainer**: in plain words + everyday analogies + figures + a results table + an FAQ. Self-contained, openable offline.

The output layout looks like:

```
<paper-name>/
├── pdf/                       original paper PDF
├── tex/                       arXiv LaTeX source (with original figures)
└── html/
    ├── images/                original figures
    └── keyword-abbrev.html    the plain-language explainer
```

HTML filename rule: `<3-6 keyword>-<model/method abbreviation>.html`, e.g. `latent-reasoning-MCOUT.html` (or `潜空间推理-MCOUT.html` in Chinese).

---

## Input forms (pick any)

| What you have | How you pass it |
|---|---|
| arXiv ID | `2508.12587` |
| arXiv URL | `https://arxiv.org/abs/2508.12587` (abs/pdf/html all fine) |
| PDF URL | `https://xxx.com/paper.pdf` |
| Local PDF file | `/path/to/paper.pdf` |
| Only a title | `Multimodal Chain of Continuous Thought` (it searches and confirms with you first) |

---

## Install & use

### 1. Claude Code

Put this repo into Claude Code's skills directory (project- or user-level):

```bash
git clone https://github.com/feng1201/paper_html.git
# user-level (available everywhere):
ln -s "$(pwd)/paper_html" ~/.claude/skills/paper-html
# or project-level:
ln -s "$(pwd)/paper_html" <your-project>/.claude/skills/paper-html
```

Then in Claude Code, just ask, or use the skill:

```
/paper-html 2508.12587
Read https://arxiv.org/abs/2508.12587 and write an easy explainer web page
```

### 2. Codex

Clone the repo and install the command into Codex's prompts directory:

```bash
git clone https://github.com/feng1201/paper_html.git
export PAPER_HTML_DIR="$(pwd)/paper_html"          # recommend adding to ~/.zshrc / ~/.bashrc
cp paper_html/prompts/paper-html.md ~/.codex/prompts/paper-html.md
# open ~/.codex/prompts/paper-html.md and set $PAPER_HTML_DIR to the real path above
```

Then in Codex:

```
/paper-html 2508.12587
```

### 3. As a plain script (any environment)

Just want to download a paper and write the explainer yourself:

```bash
bash scripts/fetch_paper.sh 2508.12587 MCOUT_latent_reasoning ./papers
```

---

## Repo layout

```
paper_html/
├── README.md                  this file (English, default)
├── README.zh-CN.md            Chinese version
├── SKILL.md                   Claude Code entry (skill definition)
├── prompts/
│   └── paper-html.md          Codex entry (/paper-html command)
├── reference/
│   ├── workflow.md            core flow (single source of truth, shared)
│   ├── writing-style.md       writing-style guide (how to be approachable)
│   └── template.html          HTML template (with self-contained color CSS)
├── scripts/
│   └── fetch_paper.sh         download script (PDF + source + figures)
└── examples/                  sample output
```

Both entry points (`SKILL.md` and `prompts/paper-html.md`) are thin shells; the real method lives in `reference/`, so editing one place updates both tools.

---

## Example

Using the paper [MCOUT (arXiv:2508.12587)](https://arxiv.org/abs/2508.12587), it produces an explainer page with original figures, analogies, a results table, and an FAQ. See `examples/` (this example is the Chinese-language output).

---

## Design principles

- **Explain it to a beginner**: every term gets an explanation and an analogy; equations are translated into plain words.
- **Honest**: the paper's limitations and failure findings are spelled out, with why they matter.
- **Self-contained**: images and styles are embedded; openable offline; no external image hosts.
- **Faithful numbers**: all data defers to the original PDF.

---

## License

MIT
