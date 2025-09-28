#!/usr/bin/env node

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Translate with Kagi
// @raycast.mode compact

// Optional parameters:
// @raycast.icon 🌐
// @raycast.argument1 { "type": "text", "placeholder": "Text to translate (optional)", "optional": true }

// Documentation:
// @raycast.author eetann
// @raycast.authorURL https://raycast.com/eetann

// quicklink: 
//   Name: Quick Translate
//   Link: raycast://script-commands/translate?arguments={selection}
//   Open With: Raycast.app
//   Hotkey: option + command + t

const { execSync } = require('child_process');

// 引数またはquicklinkから取得
const selectedText = process.argv.slice(2)[0] || "";

// Build Kagi translation URL
let url;
if (selectedText) {
  const encodedText = encodeURIComponent(selectedText);
  url = `https://translate.kagi.com/?text=${encodedText}&target=Japanese`;
} else {
  console.log("no selectedText")
  process.exit(0);
}

// Open the URL in default browser
execSync(`open "${url}"`);
