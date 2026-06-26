# /paper-html · Turn a paper into an easy HTML explainer (Codex)

> Install: copy this file to `~/.codex/prompts/paper-html.md`, and clone the `paper_html` repo locally.
> Invoke: `/paper-html <paper input>`, e.g. `/paper-html 2508.12587`, `/paper-html https://arxiv.org/abs/2508.12587`, or `/paper-html "Multimodal Chain of Continuous Thought"`.
> Set `$PAPER_HTML_DIR` below to the real path of your cloned paper_html repo (or `export PAPER_HTML_DIR=...` before invoking).

Your task: turn the paper the user gives into an **easy-to-understand HTML explainer**, and keep pdf / tex / html in tidy subfolders.

## Output language
**Follow the user's conversation language.** If the user writes to you in Chinese, produce the HTML (and your replies) in Chinese; otherwise default to English.

## Steps

1. **Read the core method files** (in the paper_html repo, referred to as `$PAPER_HTML_DIR`):
   - `$PAPER_HTML_DIR/reference/workflow.md` — full flow
   - `$PAPER_HTML_DIR/reference/writing-style.md` — writing style
   - `$PAPER_HTML_DIR/reference/template.html` — HTML skeleton
   Follow them strictly.

2. **Detect input and download**. Input may be an arXiv ID / arXiv URL / PDF URL / local PDF / or just a title.
   - Title only: web-search `<title> arxiv`, **confirm it's the right paper** first, then continue.
   - Then run the download script:
     ```bash
     bash "$PAPER_HTML_DIR/scripts/fetch_paper.sh" <input> <slug> <out-dir>
     ```
     It creates `pdf/ tex/ html/images/`, downloads the PDF + LaTeX source, and extracts figures.
     If `out-dir` isn't given, use the current directory or the user's papers folder; use a short ASCII `slug`.

3. **Read the paper, extract the skeleton**: read the main `.tex` in `tex/` (or the PDF if no source), and pull out the pain point, core idea, architecture, results, limitations, conclusion.

4. **Handle figures**: prefer original figures in `html/images/`; if no source, screenshot the PDF (`pdftoppm`/`sips`); redraw with inline SVG/HTML when clearer.

5. **Write the HTML**: copy `template.html` as the skeleton and fill it per the writing-style guide — plain words, everyday analogies, one-sentence summary, TOC, results comparison table, honest limitations, FAQ; translate equations into plain words; self-contained, openable offline. Write in the language from the output-language rule.

6. **Name and save**: save to `<slug>/html/` with filename `<3-6 keyword>-<abbreviation>.html` (e.g. `latent-reasoning-MCOUT.html`, or `潜空间推理-MCOUT.html` for Chinese).

7. **Report**: list the directory structure, give the HTML path, recap the paper in ~30 seconds, and proactively ask whether to adjust the casual/technical level or redraw a figure.

## Constraints
- Self-contained; no external CDNs; openable offline.
- Every number defers to the original PDF; don't fabricate.
- Present the paper's limitations / failure findings honestly.

The user's input is: `$ARGUMENTS`
