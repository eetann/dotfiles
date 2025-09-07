#!/usr/bin/env bun

// Usage: bun run .codex/notify.ts '<NOTIFICATION_JSON>'

type Notification = {
  type?: string;
  [key: string]: unknown;
};

function usage(): void {
  console.log("Usage: bun .codex/notify.ts <NOTIFICATION_JSON>");
}

function isStringArray(val: unknown): val is string[] {
  return Array.isArray(val) && val.every((x) => typeof x === "string");
}

function main(): number {
  // process.argv[0] = bun, argv[1] = script, argv[2] = json
  if (process.argv.length !== 3) {
    usage();
    return 1;
  }

  const raw = process.argv[2];
  let notification: Notification;
  try {
    notification = JSON.parse(raw);
  } catch {
    return 1;
  }

  const notificationType = String(notification.type ?? "");

  let title = "";
  let message = "";

  switch (notificationType) {
    case "agent-turn-complete": {
      const assistantMessage = (notification as any)["last-assistant-message"]; // eslint-disable-line @typescript-eslint/no-explicit-any
      if (typeof assistantMessage === "string" && assistantMessage.length > 0) {
        title = `Codex: ${assistantMessage}`;
      } else {
        title = "Codex: Turn Complete!";
      }
      const inputMessages = (notification as any)["input_messages"]; // eslint-disable-line @typescript-eslint/no-explicit-any
      if (isStringArray(inputMessages)) {
        message = inputMessages.join(" ");
      }
      // Preserve original behavior: append message to title as well
      title += message;
      break;
    }
    default: {
      console.log(`not sending a push notification for: ${notificationType}`);
      return 0;
    }
  }

  const result = Bun.spawnSync([
    "terminal-notifier",
    "-title",
    title,
    "-message",
    message,
    "-group",
    "codex",
    "-ignoreDnD",
    "-activate",
    "com.googlecode.iterm2",
  ]);

  if (result.exitCode !== 0) {
    const stderr = new TextDecoder().decode(result.stderr);
    console.error(stderr.trim());
    return result.exitCode ?? 1;
  }

  return 0;
}

const code = main();
// Ensure exit code is propagated in Bun/Node
process.exit(code);
