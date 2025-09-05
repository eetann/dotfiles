#!/usr/bin/env bun

import { parseArgs } from "node:util";
import { readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";

const { values } = parseArgs({
  args: Bun.argv,
  options: {
    format: {
      type: "string",
      default: "utf8",
    },
    file: {
      type: "string",
    },
  },
  strict: true,
  allowPositionals: true,
});

if (!values.file) {
  console.error("Usage: bun run ~/dotfiles/bin/csv_to_tsv.ts --file <csv-file> [--format sjis|utf8]");
  process.exit(1);
}

const csvFilePath = resolve(process.cwd(), values.file);
const format = values.format as string;

if (format !== "sjis" && format !== "utf8") {
  console.error("Error: --format must be either 'sjis' or 'utf8'");
  process.exit(1);
}

try {
  let csvContent: string;
  
  if (format === "sjis") {
    const buffer = await readFile(csvFilePath);
    const decoder = new TextDecoder("shift-jis");
    csvContent = decoder.decode(buffer);
  } else {
    csvContent = await readFile(csvFilePath, "utf8");
  }

  const parseCsvLine = (line: string): string[] => {
    const result: string[] = [];
    let current = "";
    let inQuotes = false;
    
    for (let i = 0; i < line.length; i++) {
      const char = line[i];
      const nextChar = line[i + 1];
      
      if (char === '"') {
        if (inQuotes && nextChar === '"') {
          current += '"';
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char === ',' && !inQuotes) {
        result.push(current);
        current = "";
      } else {
        current += char;
      }
    }
    
    result.push(current);
    return result;
  };

  const lines = csvContent.split(/\r?\n/);
  const tsvLines = lines.map(line => {
    if (line.trim() === "") return "";
    const fields = parseCsvLine(line);
    return fields.map(field => {
      if (field.includes("\t") || field.includes("\n") || field.includes("\r")) {
        return `"${field.replace(/"/g, '""')}"`;
      }
      return field;
    }).join("\t");
  });

  const tsvContent = tsvLines.join("\n");
  const tsvFilePath = csvFilePath.replace(/\.csv$/i, ".tsv");
  
  await writeFile(tsvFilePath, tsvContent, "utf8");
  
  console.log(`Converted: ${csvFilePath} -> ${tsvFilePath}`);
  console.log(`Input format: ${format}, Output format: UTF-8`);
} catch (error) {
  console.error("Error:", error.message);
  process.exit(1);
}
