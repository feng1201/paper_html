# paper_html · Writing-style guide

One principle: **write as if explaining to a smart friend who has zero background and calls themselves "dumb." Make them genuinely understand.**

> **Language**: write the explainer in the user's conversation language — **Chinese if the user writes in Chinese, otherwise default to English**. The guidance below applies in either language.

## Tone
- Plain words, short sentences. If you can say "in plain terms…", don't pile on jargon.
- The moment a technical term appears, explain it in one sentence or with an analogy. Don't use a term you haven't explained.
- Lean on **everyday analogies** (mental math, reading comprehension, looking up a dictionary, an assembly line…). This is what makes the explainer click.
- Don't copy equations verbatim. Translate each into "what this step does and why." Keep at most one or two symbols, with their meaning labeled.
- Be honest. Spell out the paper's limitations and "failure findings," and explain why they're still valuable — this is often the most insightful part.

## Structure (HTML blocks)
1. **Hero header**: main title + a one-line subtitle that nails the core; plus original title, authors, arXiv id, domain tags.
2. **One-sentence summary**: right at the top, so a reader gets the gist in 10 seconds.
3. **Table of contents**: anchor links so a long piece is navigable.
4. **Background / pain point**: first explain "what's wrong with current approaches" to set up motivation. Add an analogy box.
5. **Core idea**: the single key idea of the paper, highlighted on its own.
6. **Method / architecture**: with a figure (original or redrawn), explained in numbered steps.
7. **Results**: presented as a table; clearly mark "baseline vs. this method" and the improvement; remind readers "relative improvement ≠ adding that many percentage points."
8. **Limitations / failure findings**: presented honestly, with significance explained.
9. **Takeaways**: a checklist (what they did, what it's good for, what problem remains).
10. **FAQ**: 3–5 questions a layperson would most likely ask, self-answered.
11. **Companion-files note**: what each of the pdf/tex/html folders contains.

## Visual devices (matching CSS classes are in template.html)
- `card`: a normal info card.
- `card tldr`: one-sentence summary / blue highlight.
- `card analogy`: 🌟 analogy box (green).
- `card warn`: ⚠️ pain point / limitation / failure finding (yellow).
- `step`: a numbered circular step, for describing a flow.
- `table`: results comparison; mark improvements green with `.up`.
- `qa`: an FAQ question-and-answer.
- `pill` / `badge` / `key`: small tags, keyword highlights.

## Don'ts
- ❌ Don't translate the paper paragraph by paragraph (that's translation, not an explainer).
- ❌ Don't keep large blocks of equations or pile on jargon.
- ❌ Don't report only the good news.
- ❌ Don't use external image hosts/CDNs — images and styles are self-contained, openable offline.
- ❌ Don't fabricate data; every number defers to the original PDF.
