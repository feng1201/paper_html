---
name: paper-html
description: Turn an academic paper into an easy-to-understand HTML explainer with good file management. Accepts many input forms — arXiv ID, arXiv URL, PDF URL, local PDF path, or even just a paper title (auto web-search to locate it). Use when the user wants to understand/explain/break down a paper, turn a paper into a readable web page, or download an arXiv paper and explain it. Output is a self-contained HTML with a one-sentence summary, analogies, figures, a results table and an FAQ. The explainer's language follows the conversation: Chinese if the user writes in Chinese, otherwise English.
---

# paper-html · Turn a paper into an easy HTML explainer

Turn a paper (in any input form) into an explainer a total outsider can understand, and keep pdf / tex / html in tidy subfolders.

## Output language
**Follow the user's conversation language.** If the user writes to you in Chinese, produce the HTML (and your replies) in Chinese; otherwise default to English.

## Steps

1. **Read the core method**: first read, in this skill's directory, `reference/workflow.md` (full flow), `reference/writing-style.md` (writing style), and `reference/template.html` (HTML skeleton). Follow them strictly.

2. **Detect input and download**: the user may give an arXiv ID / arXiv URL / PDF URL / local PDF / or just a title.
   - Title only: web-search `<title> arxiv`, **confirm with the user it's the right paper**, then continue.
   - With an arXiv id / url / pdf, run:
     ```
     bash <skill-dir>/scripts/fetch_paper.sh <input> <slug> <out-dir>
     ```
     It creates `pdf/ tex/ html/images/` and downloads the PDF + LaTeX source + extracts figures.
   - If `out-dir` isn't given, use the current directory or the user's papers folder; use a short ASCII `slug`.

3. **Read + extract skeleton**: read the main `.tex` in `tex/` (or the PDF if no source), and extract pain point, core idea, architecture, results, limitations, conclusion.

4. **Handle figures**: prefer original figures in `html/images/`; if there's no source, screenshot the PDF (`pdftoppm`/`sips`); redraw with inline SVG/HTML when that's clearer.

5. **Write the HTML**: copy `reference/template.html` as the skeleton and fill it per `reference/writing-style.md` — plain words, analogies, one-sentence summary, TOC, results table, honest limitations, FAQ. Write in the language chosen by the output-language rule.

6. **Name and save**: save to `<slug>/html/` with filename `<3-6 keyword>-<abbreviation>.html` (e.g. `latent-reasoning-MCOUT.html`, or `潜空间推理-MCOUT.html` for Chinese).

7. **Report**: list the directory structure, give the clickable HTML path, recap the paper in ~30 seconds, and proactively ask whether to adjust the casual/technical level or redraw a figure.

## Key constraints
- Everything self-contained; images and styles don't depend on external CDNs; openable offline.
- Every number defers to the original PDF; don't fabricate.
- Present the paper's limitations / failure findings honestly — often the most valuable part.
