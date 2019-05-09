参考ファイルの写し  

# coc-settings.json  
{  
  "coc.preferences.currentFunctionSymbolAutoUpdate": true,  
  "coc.preferences.enableFloatHighlight": true,  
  "coc.preferences.jumpCommand": "tabe",  
  "coc.preferences.messageLevel": "more",  
  "coc.preferences.previewAutoClose": false,  
  "coc.source.around.shortcut": "a",  
  "coc.source.buffer.shortcut": "b",  
  "coc.source.file.shortcut": "㖄",  
  "coc.source.gocode.shortcut": "ﳑ",  
  "coc.source.ultisnips.priority": 1,  
  "coc.source.ultisnips.shortcut": "s",  
  "codeLens.enable": true,  
  "codeLens.separator": "䁓",  
  "diagnostic.displayByAle": false,  
  "diagnostic.enable": true,  
  "diagnostic.enableSign": true,  
  "diagnostic.errorSign": "哣 ",  
  "diagnostic.hintSign": "ⅳ",  
  "diagnostic.infoSign": "唣",  
  "diagnostic.messageTarget": "float",  
  "diagnostic.refreshOnInsertMode": true,  
  "diagnostic.virtualText": false,  
  "diagnostic.warningSign": "",  
  "javascript.referencesCodeLens.enable": true,  
  "snippets.ultisnips.enable": true,  
  "suggest.acceptSuggestionOnCommitCharacter": false,  
  "suggest.autoTrigger": "always",  
  "suggest.detailField": "preview",  
  "suggest.detailMaxLength": 100,  
  "suggest.disableMenu": false,  
  "suggest.enablePreview": true,  
  "suggest.localityBonus": true,  
  "suggest.maxCompleteItemCount": 50,  
  "suggest.minTriggerInputLength": 1,  
  "suggest.noselect": true,  
  "suggest.preferCompleteThanJumpPlaceholder": true,  
  "suggest.snippetIndicator": " 页 ",  
  "suggest.timeout": 1000,  
  "suggest.triggerAfterInsertEnter": true,  
  "suggest.triggerCompletionWait": 120,  
  "suggest.completionItemKindLabels": {  
    "method": "牜 ",  
    "field": "参 ",  
    "text": "箲 ",  
    "unit": " ",  
    "enum": "ﬧ ",  
    "file": "ぷ",  
    "class": "榟 ",  
    "value": "ﲵ ",  
    "color": "凇 ",  
    "function": "ル",  
    "module": "啹 ",  
    "event": "ﰆ ",  
    "snippet": "涱 ",  
    "interface": " ",  
    "property": "識",  
    "folder": " ",  
    "variable": " ",  
    "struct": "ﬥ ",  
    "keyword": " ",  
    "constant": "沜 ",  
    "default": "陼",  
    "operator": "ﬦ",  
    "reference": "⑩",  
    "enumMember": " ",  
    "typeParameter": " "  
  },  
}  
{  
  "tsserver.enableJavascript": false,  
  "languageserver": {  
    "flow": {  
      "command": "flow",  
      "args": ["lsp"],  
      "filetypes": ["javascript", "javascriptreact"],  
      "initializationOptions": {},  
      "requireRootPattern": true,  
      "settings": {},  
      "rootPatterns": [".flowconfig"]  
    }  
  },  

  "solargraph.commandPath": "/Users/igor/.rbenv/versions/2.4.1/bin/solargraph",  

  "diagnostic.errorSign": "🚫",  
  "diagnostic.warningSign": "⚠️",  
  "diagnostic.infoSign": "ℹ️",  

  "coc.preferences.currentFunctionSymbolAutoUpdate": true  


}  
{  
  "languageserver": {  
    "clangd": {  
      "command": "clangd",  
      "rootPatterns": ["compile_flags.txt", "compile_commands.json", ".vim/", ".git/", ".hg/"],  
      "filetypes": ["c", "cpp", "objc", "objcpp"]  
    },  
    "haskell": {  
      "command": "hie-wrapper",  
      "rootPatterns": [  
        ".stack.yaml",  
        "cabal.config",  
        "package.yaml"  
      ],  
      "filetypes": [  
        "hs",  
        "lhs",  
        "haskell"  
      ],  
      "initializationOptions": {}  
    },  
    "python":{  
        "command": "pyls",  
        "filetypes": [  
            "py",  
            "python"  
        ],  
        "initializationOptions": {}  
    }  
  }  
}  
{  
  "languageserver": {  
    "clangd": {  
      "command": "clangd",  
      "rootPatterns": ["compile_flags.txt", "compile_commands.json", ".vim/", ".git/", ".hg/"],  
      "filetypes": ["c", "cpp", "objc", "objcpp"]  
    },  
    "haskell": {  
      "command": "hie-wrapper",  
      "rootPatterns": [  
        ".stack.yaml",  
        "cabal.config",  
        "package.yaml"  
      ],  
      "filetypes": [  
        "hs",  
        "lhs",  
        "haskell"  
      ],  
      "initializationOptions": {}  
    },  
    "python":{  
        "command": "pyls",  
        "filetypes": [  
            "py",  
            "python"  
        ],  
        "initializationOptions": {}  
    }  
  }  
}  
{  
  "diagnostic.displayByAle": true,  
  "coc.preferences.formatOnType": false  
}  

{  
        "suggest.triggerAfterInsertEnter": true,  
        "suggest.timeout": 500,  
        "suggest.noselect": true,  
        "suggest.minTriggerInputLength": 2,  
        "suggest.snippetIndicator": "^",  
        "suggest.enablePreview": true,  
        "suggest.detailMaxLength": 88,  
        "snippets.loadFromExtensions": true,  
        "snippets.ultisnips.enable": true,  
        "snippets.ultisnips.directories": ["Ultisnips"],  
        "snippets.snipmate.enable": false,  
        "diagnostic.refreshOnInsertMode": true,  
        "diagnostic.enableSign": true,  
        "diagnostic.messageTarget": "echo",  
        "signature.enable": true,  
        "signature.target": "echo",  
        "list.maxHeight": 20,  
        "list.maxPreviewHeight": 20,  
        "highlight.document.enable": true,  
        "highlight.colors.enable": true,  
        "coc.preferences.hoverTarget": "float",  
        "coc.preferences.jumpCommand": "split",  
        "coc.preferences.colorSupport": true,  
        "python.jediEnabled": false,  
        "python.formatting.provider": "black",  
        "python.formatting.blackPath": "/home/rbpatt2019/.pyenv/shims/black",  
        "python.linting.enabled": true,  
        "python.linting.mypyEnabled": false,  
        "python.linting.pylintEnabled": false,  
        "python.venvPath": "~/.pyenv/versions"  
}  


{  
  "coc.preferences.extensionUpdateCheck": "never",  
  "coc.preferences.jumpCommand": "edit",  
  "coc.preferences.formatOnSaveFiletypes": [  
    "json",  
    "javascript",  
    "javascriptreact",  
    "css",  
    "html",  
    "Markdown"  
  ],  
  "diagnostic.errorSign": "✘",  
  "diagnostic.warningSign": "",  
  "suggest.snippetIndicator": "➤",  
  "diagnostic.refreshOnInsertMode": true,  
  "snippets.ultisnips.directories": ["ultiSnippets"],  
  <!-- "pairs.enableCharacters": ["(", "[", "{", "'", "\"", "`"],   -->  
  "tsserver.orgnizeImportOnSave": false,  
  "javascript.validate.enable": false,  
  "javascript.preferences.quoteStyle": "single",  
  "eslint.packageManager": "npm",  
  "eslint.options": {  
    "configFile": "/home/mg0x16/Workspace/dotfiles/linters/eslintrc.json"  
  },  
  "prettier.singleQuote": false,  
  "prettier.trailingComma": "all"  
}  
{  
    "languageserver": {  
        "golang": {  
            "command": "bingo",  
            "rootPatterns": ["go.mod", ".vim/", ".git/", ".hg/"],  
            "filetypes": ["go"]  
        }  
    },  
    "pairs.disableLanguages": ["markdown"]  
}  

{  
  "coc.preferences.colorSupport": true,  
  "coc.preferences.extensionUpdateCheck": "daily",  
  "coc.preferences.formatOnSaveFiletypes": ["javascript", "typescript", "typescriptreact", "json", "javascriptreact"],  
  "coc.preferences.formatOnType": false,  
  "coc.preferences.hoverTarget": "float",  
  "coc.preferences.jumpCommand": "vsplit",  
  "coc.preferences.previewAutoClose": true,  
  "coc.preferences.snippets.enable": true,  
  "coc.preferences.snippetStatusText": "🌈",  
  "coc.preferences.enableFloatHighlight": true,  

  "signature.enable": true,  
  "signature.target": "float",  
  "signature.preferShownAbove": true,  
  "signature.hideOnTextChange": true,  
  "signature.maxWindowHeight": 8,  

  "suggest.acceptSuggestionOnCommitCharacter": true,  
  "suggest.autoTrigger": "always",  
  "suggest.detailField": "abbr",  
  "suggest.detailMaxLength": 30,  
  "suggest.echodocSupport": false,  
  "suggest.enablePreview":true,  
  "suggest.localityBonus": true,  
  "suggest.maxCompleteItemCount": 20,  
  "suggest.maxPreviewWidth": 60,  
  "suggest.minTriggerInputLength": 2,  
  "suggest.noselect": false,  
  "suggest.numberSelect": false,  
  "suggest.preferCompleteThanJumpPlaceholder": true,  
  "suggest.snippetIndicator": " [S]",  
  "suggest.timeout": 5000,  
  "suggest.triggerAfterInsertEnter": false,  
  "suggest.completionItemKindLabels": {  
    "function": "\uf794",  
    "method": "\uf6a6",  
    "variable": "\uf71b",  
    "constant": "\uf8ff",  
    "struct": "\ufb44",  
    "class": "\uf0e8",  
    "interface": "\ufa52",  
    "text": "\ue612",  
    "enum": "\uf435",  
    "enumMember": "\uf02b",  
    "module": "\uf668",  
    "color": "\ue22b",  
    "property": "\ufab6",  
    "field": "\uf93d",  
    "unit": "\uf475",  
    "file": "\uf471",  
    "value": "\uf8a3",  
    "event": "\ufacd",  
    "folder": "\uf115",  
    "keyword": "\uf893",  
    "snippet": "\uf64d",  
    "operator": "\uf915",  
    "reference": "\uf87a",  
    "typeParameter": "\uf278",  
    "default": "\uf29c"  
  },  

  "diagnostic.displayByAle": false,  
  "diagnostic.enable": true,  
  "diagnostic.enableMessage": "always",  
  "diagnostic.enableSign": true,  
  "diagnostic.errorSign": "✖",  
  "diagnostic.highlightOffset": 9999999,  
  "diagnostic.hintSign": "~",  
  "diagnostic.infoSign": "‣",  
  "diagnostic.locationlist": false,  
  "diagnostic.messageTarget": "float",  
  "diagnostic.refreshAfterSave": false,  
  "diagnostic.refreshOnInsertMode": true,  
  "diagnostic.signOffset": 9999999,  
  "diagnostic.virtualText": false,  
  "diagnostic.virtualTextLineSeparator": "//",  
  "diagnostic.virtualTextLines": 3,  
  "diagnostic.virtualTextPrefix": "‣❯ ",  
  "diagnostic.warningSign": "⬥",  

  "codeLens.enable": true,  
  "codeLens.separator": "‣❯",  

  "highlight.disableLanguages": [],  
  "highlight.document.enable": true,  
  "highlight.colors.enable": true,  

  "javascript.suggest.autoImports": true,  
  "typescript.suggest.autoImports": true,  

  // emmet  
  /* "emmet.showAbbreviationSuggestions": false, */  

  // prettier  
  "prettier.eslintIntegration": true,  
  "prettier.tslintIntegration": true,  
  "prettier.stylelintIntegration": true,  

  // eslint  
  "eslint.filetypes": ["javascript", "typescript", "typescriptreact", "javascriptreact"],  
  "eslint.autoFix": true,  
  "eslint.autoFixOnSave": true,  

  // tslint  
  "tslint.autoFixOnSave": true,  

  // yaml  
  "yaml.schemas": {  
    "http://json.schemastore.org/composer": "/*"  
  },  

  "snippets.autoTrigger": true,  

  // sources  
  "coc.source.around.enable": true,  
  "coc.source.around.shortcut": "A",  
  "coc.source.around.priority": 8,  
  "coc.source.buffer.enable": true,  
  "coc.source.buffer.shortcut": "B",  
  "coc.source.buffer.priority": 6,  
  "coc.source.buffer.ignoreGitignore": true,  
  "coc.source.dictionary.enable": true,  
  "coc.source.dictionary.filetypes": ["markdown", "gitcommit"],  
  "coc.source.emoji.enable": false,  
  "coc.source.emoji.filetypes": ["markdown", "gitcommit"],  
  "coc.source.file.enable": true,  
  "coc.source.file.shortcut": "F",  
  "coc.source.file.priority": 7,  
  "coc.source.file.triggerCharacters": ["/"],  
  "coc.source.file.trimSameExts": [".ts", ".js"],  
  "coc.source.file.ignoreHidden": true,  
  "coc.source.file.ignorePatterns": [],  
  "coc.source.syntax.enable": false,  
  "coc.source.tag.enable": true,  
  "coc.source.tag.priority": 7,  
  "coc.source.word.enable": true,  
  "coc.source.word.filetypes": ["markdown", "gitcommit"],  

  // tailwind css  
  "tailwind.enable": true,  
  "tailwind.shortcut": "TWCSS",  
  "tailwind.priority": 99,  

  // git  
  "git.enableGutters": true,  
  "git.signOffset": 99,  
  "git.branchCharacter": "⎇",  
  "git.addedSign.text": "▏",  
  "git.addedSign.hlGroup": "CocGitAddedSign",  
  "git.changedSign.text": "▏",  
  "git.changedSign.hlGroup": "CocGitChangedSign",  
  "git.removedSign.text": "▏",  
  "git.removedSign.hlGroup": "CocGitRemovedSign",  
  "git.topRemovedSign.text": "‾",  
  "git.changeRemovedSign.text": "≃",  

  // diagnostic-languageserver  
  /* "diagnostic-languageserver.filetypes": { */  
  /*   "vim": "vint", */  
  /*   "markdown": [ "write-good", "markdownlint" ], */  
  /*   "sh": "shellcheck", */  
  /*   "elixir": "credo", */  
  /*   "eelixir": "credo" */  
  /* }, */  
  /* "diagnostic-languageserver.linters": { */  
  /*   "elixir": "credo", */  
  /*   "eelixir": "credo" */  
  /* }, */  
  /* "diagnostic-languageserver.formatFiletypes": { */  
  /*   "elm": "elm-format", */  
  /*   "elixir": "mix format", */  
  /*   "eelixir": "mix format" */  
  /* }, */  
  /* "diagnostic-languageserver.formatters": { */  
  /*   "elm": "elm-format", */  
  /*   "elixir": "mix format", */  
  /*   "eelixir": "mix format" */  
  /* }, */  

  // languageserver  
  "languageserver": {  
    "sh": {  
      "command": "bash-language-server",  
      "args": ["start", "--stdio"],  
      "filetypes": ["sh", "bash", "zsh", "shell"],  
      "cwd": "./",  
      "initializationOptions": {},  
      "settings": {}  
    },  
    "elm": {  
      "command": "elm-lsp",  
      "args": ["--stdio"],  
      "filetypes": ["elm"],  
      "cwd": ".",  
      "rootPatterns": ["elm.json"],  
      "initializationOptions": {  
        "runtime": "node"  
      },  
      "settings": {}  
    },  
    "elixir": {  
      "command": "./.elixir_ls/rel/language_server.sh",  
      "args": [],  
      "filetypes": ["elixir", "eelixir", "ex", "exs", "eex"],  
      "trace.server": "verbose",  
      "rootPatterns": ["mix.exs"],  
      "cwd": "./",  
      "initializationOptions": {  
        "elixirLS": {  
          "dialyzerEnabled": false,  
          "dialyzerWarningOpts": []  
        }  
      },  
      "settings": {}  
    },  
    "python": {  
      "command": "pyls",  
      "filetypes": ["python", "pythonx", "py"],  
      "args": []  
    },  
    "lua": {  
      "command": "lua-lsp",  
      "filetypes": ["lua"]  
    }  
  }  
}  
{  
    "suggest": {  
        "formatOnSaveFiletypes": ["rust", "python"],  
        "noselect": false,  
        "preferCompleteThanJumpPlaceholder": true  
    },  
    "diagnostic": {  
        "hintSign": "⯇'",  
        "infoSign": "⯇'",  
        "errorSign": "⮿",  
        "warningSign": "⯀"  
    },  
    "eslint": {  
        "enable": true,  
        "eslint.createConfig": true,  
        "filetypes": ["javascript", "javascriptreact", "html"]  
    },  
    "languageserver": {  
        "sh": {  
            "command": "bash-language-server",  
            "args": ["start"],  
            "filetypes": ["sh"]  
        },  
        "cquery": {  
            "command": "cquery",  
            "filetypes": ["c", "cpp", "objc", "objcpp"]  
        },  
        "dockerfile": {  
            "command": "docker-langserver",  
            "args": ["--stdio", "start"],  
            "filetypes": ["dockerfile"]  
        },  
        "r": {  
            "command": "R",  
            "args": ["--quiet", "--slave", "-e", "languageserver::run(debug=TRUE)"],  
            "filetypes": ["r", "rmarkdown"]  
        }  
    },  
    "html": {  
        "validate.scripts": true,  
        "validate.styles": true,  
        "html.format.enable": true  
    },  
    "pyls": {  
        "trace.server": "silent",  
        "configurationSources": ["flake8"],  
        "plugins": {  
            "mypy": {  
                "enabled": true  
            },  
            "rope": {  
                "enabled": false  
            },  
            "black": {  
                "enabled": true  
            },  
            "pydocstyle": {  
                "enabled": true  
            },  
            "pycodestyle": {  
                "enabled": false  
            }  
        }  
    },  
    "python": {  
        "formatting.provider": "black",  
        "python.linting.pylintEnabled": false,  
        "python.linting.flake8Enabled": true  
    }  

{  
	"coc.preferences.currentFunctionSymbolAutoUpdate": true,  

	"git.branchCharacter": "㑽",  

	"languageserver": {  
		"go-langserver": {  
			"command": "go-langserver",  
			"filetypes": ["go"],  
			"rootPatterns": ["go.mod", ".git/"],  
			"initializationOptions": {  
				"gocodeCompletionEnabled": true,  
				"diagnosticsEnabled": true,  
				"lintTool": "golint"  
			}  
		},  

		"pyls": {  
			"command": "pyls",  
			"filetypes": ["python"],  
			"rootPatterns": ["setup.py", ".git/"]  
		}  
	}  
}  

