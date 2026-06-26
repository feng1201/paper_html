# paper_html · Workflow (core method, shared by both tools)

Goal: given a paper (in any input form), produce an **easy-to-understand HTML explainer** and keep files well organized.

## Output language rule (read first)

> **The explainer's language follows the user's conversation language.**
> If the user is writing to you in Chinese, produce the HTML (and your replies) in **Chinese**.
> Otherwise, **default to English**.
> Match the language of the headings, body text, captions, tables, and FAQ to that choice. `template.html` placeholders are written in English — translate them when the target language is Chinese.

---

## Step 0 — Detect the input type and obtain the paper

The user may give one of four input forms. Handle each:

| Input form | What to do |
|---|---|
| **arXiv ID** (e.g. `2508.12587`) | Call `scripts/fetch_paper.sh <id> <slug> <out-dir>` |
| **arXiv URL** (abs/pdf/html all fine) | Same — the script parses the id automatically |
| **Plain PDF URL / local PDF path** | Same — the script downloads or copies the PDF (a local PDF has no source, so figures must be screenshotted from the PDF) |
| **Only a title** (even partial) | First do a **web search** `<title> arxiv`, find the arXiv page, **confirm with the user it's the right paper**, then call the script with the id |

> `<slug>`: a short ASCII name (letters/digits/underscore) for the folder, e.g. `MCOUT_latent_reasoning`.
> `<out-dir>`: where to place the paper; if the user didn't specify, use the current directory or the user's papers folder.

The script creates a standard layout:
```
<out-dir>/<slug>/
  ├── pdf/          paper PDF
  ├── tex/          arXiv LaTeX source (if available)
  └── html/images/  figures extracted from the source
```

---

## Step 1 — Read the paper and extract its skeleton

Read the main `.tex` in `tex/` (most complete — has equations and figure captions); if there is no source, read the PDF in `pdf/`.

Extract the information you'll need to write the explainer:
- **Title / authors / affiliation / arXiv id / year**
- **The pain point it solves** (state it in one plain sentence)
- **The core idea / method** (its key difference from prior work)
- **Model / system architecture** (what each part does)
- **Key figures** (which ones are worth putting in the explainer)
- **Experimental results** (main tables, relative improvements)
- **Limitations / honest failure findings** (good papers have them — present them honestly; often the most valuable part)
- **Conclusion and significance**

---

## Step 2 — Prepare figures

- **Prefer original figures**: `scripts/fetch_paper.sh` already extracted raster figures (png/jpg) into `html/images/`. Pick the clearest, most informative ones, reference them as `<img src="images/xxx.png">`, and write a caption explaining "what this figure shows and how to read it" (in the target language).
- **Vector figures (`.pdf`/`.eps`) must be converted to PNG** — many arXiv papers ship figures as PDF. Use the bundled helper, which renders the **whole** figure at high resolution:
  ```
  bash <skill-dir>/scripts/pdf_to_png.sh tex/figures/teaser.pdf html/images/teaser.png 1400
  ```
  ⚠️ **Do NOT use `sips -s format png` on a vector PDF** — it silently **crops/clips** the figure (commonly the left edge). The helper uses macOS `qlmanage` (renders the full figure), then `pdftoppm`/`magick`/`sips` as fallbacks. **After converting, always open the PNG with the Read tool and verify nothing is cut off** (titles, left/right columns, edges) before using it.
- **No source / need a specific page**: screenshot the PDF page (`pdftoppm -png -r 150 -f <page> -l <page> paper.pdf out`, or read the PDF page with the Read tool and describe it). Save into `html/images/`.
- **When a redraw is clearer**: draw the diagram with **inline SVG or plain HTML/CSS** (flows, loops, side-by-side comparisons) — never depend on an external image host. The goal of a redraw is to make it understandable to a total beginner: numbered steps, two-column comparisons, etc.

---

## Step 3 — Write the HTML explainer

- Copy `reference/template.html` as the skeleton (self-contained color CSS, responsive for phone/desktop).
- Follow `reference/writing-style.md` strictly: **explain it as if to a smart beginner**, use everyday analogies, lead with a one-sentence summary, include a TOC, cards, tables, and an FAQ; translate equations into plain words; be honest about limitations.
- Suggested section order: title hero → one-sentence summary → TOC → background/pain point → core idea → architecture figure → how the method works → results → limitations/failure findings → takeaways → FAQ → companion-files note.
- **Write everything in the target language chosen by the output-language rule above.**

---

## Step 4 — Naming and saving

- Save the HTML under `<slug>/html/`.
- **Filename rule**: `<3-6 keyword>-<model/method abbreviation>.html`. Use a short domain keyword + the abbreviation. Chinese example: `潜空间推理-MCOUT.html`. English example: `latent-reasoning-MCOUT.html`. Keep it short and meaningful.

---

## Step 5 — Report back

- List the final directory structure (pdf / tex / html subfolders).
- Give the clickable relative path to the HTML.
- Recap what the paper is about in ~30 seconds.
- Proactively ask whether to: adjust the casual/technical level, add more examples, or redraw a figure.

---

## Pre-delivery self-check
- [ ] Output language matches the conversation language (Chinese if the user writes Chinese, else English)?
- [ ] File management correct? pdf / tex / html separated, figures in html/images.
- [ ] HTML filename follows "keyword + abbreviation"?
- [ ] Could a complete outsider understand it? Any term thrown in without explanation?
- [ ] Key numbers (improvements, comparisons) accurate? The original PDF is the source of truth.
- [ ] Did you present the paper's limitations / failure findings honestly?
- [ ] Do figures display (relative path, files actually in images/)?
