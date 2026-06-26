#!/usr/bin/env bash
# fetch_paper.sh — 下载一篇论文（PDF + LaTeX 源码 + 图片），并建立标准目录结构。
#
# 用法:
#   ./fetch_paper.sh <arxiv-id | arxiv-url | pdf-url | 本地pdf路径> <slug> [out-dir]
#
# 示例:
#   ./fetch_paper.sh 2508.12587            MCOUT_latent_reasoning  ./papers
#   ./fetch_paper.sh https://arxiv.org/abs/2508.12587  MCOUT      ./papers
#   ./fetch_paper.sh https://example.com/foo.pdf        FooNet    ./papers
#   ./fetch_paper.sh /path/to/local.pdf                 BarNet    ./papers
#
# 产出目录:
#   <out-dir>/<slug>/
#     ├── pdf/          # 论文 PDF
#     ├── tex/          # arXiv LaTeX 源码（如有）
#     └── html/images/  # 从源码里抽出来的图片（HTML 直接引用）
#
# 说明: "只给文章名" 这种输入由上层 agent 先做 web 搜索拿到 arXiv id，再调用本脚本。

set -euo pipefail

INPUT="${1:?需要 arxiv id / url / pdf-url / 本地 pdf 路径}"
SLUG="${2:?需要一个 slug 作为输出文件夹名（英文/数字/下划线）}"
OUTROOT="${3:-.}"

DEST="$OUTROOT/$SLUG"
mkdir -p "$DEST/pdf" "$DEST/tex" "$DEST/html/images"

UA="Mozilla/5.0 (paper_html fetch script)"

# 1) 本地 PDF —— 直接复制
if [[ -f "$INPUT" && "$INPUT" == *.pdf ]]; then
  echo "本地 PDF: $INPUT"
  cp "$INPUT" "$DEST/pdf/${SLUG}.pdf"
  echo "（本地 PDF 没有 LaTeX 源码；如需图片请用 pdftoppm/sips 截图，见 reference/workflow.md）"
  echo ""
  echo "完成。PDF 已放入: $DEST/pdf/"
  exit 0
fi

# 2) 从输入里尝试解析 arXiv id（形如 2508.12587 或 2508.12587v2）
ARXIV_ID=""
if [[ "$INPUT" =~ ([0-9]{4}\.[0-9]{4,5}) ]]; then
  ARXIV_ID="${BASH_REMATCH[1]}"
fi

if [[ -n "$ARXIV_ID" ]]; then
  echo "识别到 arXiv id: $ARXIV_ID"

  echo "→ 下载 PDF…"
  curl -sL -A "$UA" -o "$DEST/pdf/${SLUG}_${ARXIV_ID}.pdf" "https://arxiv.org/pdf/${ARXIV_ID}"

  echo "→ 下载 LaTeX 源码 (e-print)…"
  if curl -sfL -A "$UA" -o "$DEST/tex/source.tar.gz" "https://arxiv.org/e-print/${ARXIV_ID}"; then
    # 源码可能是 tar.gz，也可能是单个 gzip 过的 .tex
    if tar -tzf "$DEST/tex/source.tar.gz" >/dev/null 2>&1; then
      tar -xzf "$DEST/tex/source.tar.gz" -C "$DEST/tex"
    elif file "$DEST/tex/source.tar.gz" | grep -qi 'gzip'; then
      gunzip -c "$DEST/tex/source.tar.gz" > "$DEST/tex/main.tex" 2>/dev/null || true
    fi
    # 把图片抽到 html/images 供 HTML 引用
    find "$DEST/tex" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' \) \
      -exec cp {} "$DEST/html/images/" \; 2>/dev/null || true
  else
    echo "  （该论文没有公开 LaTeX 源码，跳过；图片可从 PDF 截图）"
  fi
else
  # 3) 当作一个普通的 PDF 直链
  echo "未识别到 arXiv id，按 PDF 直链处理"
  curl -sL -A "$UA" -o "$DEST/pdf/${SLUG}.pdf" "$INPUT"
fi

echo ""
echo "完成。目录结构:"
find "$DEST" -maxdepth 2 -type d | sort
echo ""
echo "PDF:"
ls "$DEST/pdf" 2>/dev/null || true
echo "抽取到的图片:"
ls "$DEST/html/images" 2>/dev/null && [ "$(ls -A "$DEST/html/images" 2>/dev/null)" ] || echo "  （无 —— 可能需要从 PDF 截图，见 reference/workflow.md）"
