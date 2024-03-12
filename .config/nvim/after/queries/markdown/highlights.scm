; extends
; {/* hoge */}をコメントと同じ色にする
((paragraph) @comment
  (#lua-match? @comment "%/%*.-%*%/"))

; 引用箇所全体を別の色にする
(block_quote) @text.reference
