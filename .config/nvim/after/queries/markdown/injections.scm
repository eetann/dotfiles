; extends
; syntax highlighting for tsx comments
((inline) @injection.content
  (#lua-match? @injection.content "^%s*{/*")
  (#set! injection.language "tsx"))

; https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
((inline) @injection.content
  (#lua-match? @injection.content "^%s*import")
  (#set! injection.language "tsx"))
((inline) @injection.content
  (#lua-match? @injection.content "^%s*export")
  (#set! injection.language "tsx"))
