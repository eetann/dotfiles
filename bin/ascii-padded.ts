#!/usr/bin/env bun

import { parseArgs } from "node:util";

const { values, positionals } = parseArgs({
  args: Bun.argv,
  options: {
    decode: {
      type: "boolean",
      short: "d",
      default: false,
    },
    help: {
      type: "boolean",
      short: "h",
      default: false,
    },
  },
  strict: true,
  allowPositionals: true,
});

if (values.help) {
  console.log(`Usage: ascii-padded [OPTIONS] <text>

Encode text to zero-padded ASCII codes or decode back to text.

Options:
  -d, --decode  Decode zero-padded ASCII codes to text
  -h, --help    Show this help message

Examples:
  ascii-padded "100001"           # Output: 049048048048048049
  ascii-padded -d 049048048048048049  # Output: 100001`);
  process.exit(0);
}

const input = positionals[2];

if (!input) {
  console.error("Error: No input provided");
  console.error("Usage: ascii-padded [--decode] <text>");
  process.exit(1);
}

function encode(text: string): string {
  return [...text].map((char) => char.charCodeAt(0).toString().padStart(3, "0")).join("");
}

function decode(encoded: string): string {
  if (encoded.length % 3 !== 0) {
    console.error("Error: Input length must be a multiple of 3");
    process.exit(1);
  }

  const result: string[] = [];
  for (let i = 0; i < encoded.length; i += 3) {
    const code = parseInt(encoded.slice(i, i + 3), 10);
    if (isNaN(code)) {
      console.error(`Error: Invalid ASCII code at position ${i}: ${encoded.slice(i, i + 3)}`);
      process.exit(1);
    }
    result.push(String.fromCharCode(code));
  }
  return result.join("");
}

if (values.decode) {
  console.log(decode(input));
} else {
  console.log(encode(input));
}
