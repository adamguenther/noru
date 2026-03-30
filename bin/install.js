#!/usr/bin/env node

// noru installer
// Installs commands, hooks, and settings for Claude Code.
// No external dependencies -- Node.js builtins only.

const fs = require("fs");
const path = require("path");
const os = require("os");
const readline = require("readline");

// ---------------------------------------------------------------------------
// Paths
// ---------------------------------------------------------------------------

const NORU_ROOT = path.resolve(__dirname, "..");
const NORU_COMMANDS = path.join(NORU_ROOT, "commands", "noru");
const NORU_HOOKS = path.join(NORU_ROOT, "hooks");
const HOME = os.homedir();

function globalPaths() {
  const claude = path.join(HOME, ".claude");
  return {
    claude,
    commands: path.join(claude, "commands", "noru"),
    hooks: path.join(claude, "hooks", "noru"),
    settings: path.join(claude, "settings.json"),
    noruRoot: path.join(claude, "noru"), // symlink for soul/tracks/steps references
  };
}

function localPaths() {
  const claude = path.join(process.cwd(), ".claude");
  return {
    claude,
    commands: path.join(claude, "commands", "noru"),
    hooks: path.join(claude, "hooks", "noru"),
    settings: path.join(claude, "settings.json"),
    noruRoot: path.join(claude, "noru"),
  };
}

// ---------------------------------------------------------------------------
// Utilities
// ---------------------------------------------------------------------------

function log(msg) {
  console.log(msg);
}

function fail(msg) {
  console.error(`\n  Error: ${msg}\n`);
  process.exit(1);
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

// Check whether a path is a symlink pointing to our commands directory.
function isNoruSymlink(target) {
  try {
    const stat = fs.lstatSync(target);
    if (!stat.isSymbolicLink()) return false;
    const resolved = fs.realpathSync(target);
    return resolved === fs.realpathSync(NORU_COMMANDS);
  } catch {
    return false;
  }
}

function hasHookFiles() {
  if (!fs.existsSync(NORU_HOOKS)) return false;
  const entries = fs.readdirSync(NORU_HOOKS).filter((f) => !f.startsWith("."));
  return entries.length > 0;
}

// ---------------------------------------------------------------------------
// Settings.json merge
// ---------------------------------------------------------------------------

// The noru SessionStart hook entry. This gets appended to the hooks array
// only if no existing entry matches. Adjust when hooks are actually created.
function noruHookEntry(hooksDir) {
  return {
    hooks: [
      {
        command: path.join(hooksDir || path.join(HOME, ".claude", "hooks", "noru"), "session-start"),
        type: "command",
      },
    ],
  };
}

function readSettings(settingsPath) {
  if (!fs.existsSync(settingsPath)) return {};
  try {
    return JSON.parse(fs.readFileSync(settingsPath, "utf-8"));
  } catch {
    fail(`Could not parse ${settingsPath}. Fix or remove it and try again.`);
  }
}

function backupSettings(settingsPath) {
  if (!fs.existsSync(settingsPath)) return;
  const backup = settingsPath + ".noru-backup";
  fs.copyFileSync(settingsPath, backup);
}

function hasNoruHook(settings) {
  const sessionStart = settings?.hooks?.SessionStart;
  if (!Array.isArray(sessionStart)) return false;
  return sessionStart.some((entry) =>
    entry?.hooks?.some((h) => typeof h.command === "string" && h.command.includes("hooks/noru/"))
  );
}

function mergeHookSettings(settingsPath, hooksDir) {
  if (!hasHookFiles()) return false;

  backupSettings(settingsPath);
  const settings = readSettings(settingsPath);

  if (hasNoruHook(settings)) return false; // already present

  if (!settings.hooks) settings.hooks = {};
  if (!Array.isArray(settings.hooks.SessionStart)) settings.hooks.SessionStart = [];

  settings.hooks.SessionStart.push(noruHookEntry(hooksDir));

  ensureDir(path.dirname(settingsPath));
  fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + "\n");
  return true;
}

function removeNoruHookSettings(settingsPath) {
  if (!fs.existsSync(settingsPath)) return false;

  backupSettings(settingsPath);
  const settings = readSettings(settingsPath);

  const sessionStart = settings?.hooks?.SessionStart;
  if (!Array.isArray(sessionStart)) return false;

  const filtered = sessionStart.filter(
    (entry) => !entry?.hooks?.some((h) => typeof h.command === "string" && h.command.includes("hooks/noru/"))
  );

  if (filtered.length === sessionStart.length) return false; // nothing to remove

  settings.hooks.SessionStart = filtered;
  if (filtered.length === 0) delete settings.hooks.SessionStart;
  if (Object.keys(settings.hooks).length === 0) delete settings.hooks;

  fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2) + "\n");
  return true;
}

// ---------------------------------------------------------------------------
// Copy hooks (filters out dotfiles like .gitkeep)
// ---------------------------------------------------------------------------

function copyHooks(targetDir) {
  if (!hasHookFiles()) return false;

  ensureDir(targetDir);
  const files = fs.readdirSync(NORU_HOOKS).filter((f) => !f.startsWith("."));
  for (const file of files) {
    fs.copyFileSync(path.join(NORU_HOOKS, file), path.join(targetDir, file));
  }
  return true;
}

function removeHooks(targetDir) {
  if (!fs.existsSync(targetDir)) return false;
  fs.rmSync(targetDir, { recursive: true, force: true });
  return true;
}

// ---------------------------------------------------------------------------
// Install
// ---------------------------------------------------------------------------

function install(paths) {
  const isGlobal = paths === globalPaths() || paths.claude.startsWith(HOME);
  const label = isGlobal ? "globally" : "for this project";

  // Verify Claude Code is present (for global install)
  if (isGlobal && !fs.existsSync(path.join(HOME, ".claude"))) {
    fail("Claude Code not detected (~/.claude/ not found). Install Claude Code first.");
  }

  // Verify noru source commands exist
  if (!fs.existsSync(NORU_COMMANDS)) {
    fail(`Commands directory not found at ${NORU_COMMANDS}. Is noru intact?`);
  }

  log(`\nInstalling noru ${label} for Claude Code...\n`);

  // 1. Symlink commands
  if (fs.existsSync(paths.commands)) {
    if (isNoruSymlink(paths.commands)) {
      log(`  Commands:  ${paths.commands} (already linked)`);
    } else {
      fail(`${paths.commands} already exists and is not a noru symlink. Remove it manually to proceed.`);
    }
  } else {
    ensureDir(path.dirname(paths.commands));
    fs.symlinkSync(NORU_COMMANDS, paths.commands);
    log(`  Commands:  ${paths.commands} (symlinked)`);
  }

  // 2. Symlink noru root (for @~/.claude/noru/soul/* references in commands)
  if (fs.existsSync(paths.noruRoot)) {
    try {
      const stat = fs.lstatSync(paths.noruRoot);
      if (stat.isSymbolicLink() && fs.realpathSync(paths.noruRoot) === fs.realpathSync(NORU_ROOT)) {
        log(`  Root:      ${paths.noruRoot} (already linked)`);
      } else {
        log(`  Root:      ${paths.noruRoot} exists (skipped)`);
      }
    } catch {
      log(`  Root:      ${paths.noruRoot} exists (skipped)`);
    }
  } else {
    fs.symlinkSync(NORU_ROOT, paths.noruRoot);
    log(`  Root:      ${paths.noruRoot} (symlinked)`);
  }

  // 3. Copy hooks
  if (copyHooks(paths.hooks)) {
    // Make session-start executable
    const sessionStart = path.join(paths.hooks, "session-start");
    if (fs.existsSync(sessionStart)) {
      try { fs.chmodSync(sessionStart, 0o755); } catch { /* Windows */ }
    }
    log(`  Hooks:     ${paths.hooks} (copied)`);
  } else {
    log(`  Hooks:     (none to install)`);
  }

  // 4. Merge settings
  if (hasHookFiles()) {
    if (mergeHookSettings(paths.settings, paths.hooks)) {
      log(`  Settings:  ${paths.settings} (merged)`);
    } else {
      log(`  Settings:  ${paths.settings} (already configured)`);
    }
  }

  log(`\nDone. Run /noru:go in Claude Code to get started.\n`);
}

// ---------------------------------------------------------------------------
// Uninstall
// ---------------------------------------------------------------------------

function uninstall() {
  log("\nRemoving noru...\n");
  let removed = false;

  // Check both global and local
  for (const paths of [globalPaths(), localPaths()]) {
    if (fs.existsSync(paths.commands)) {
      if (isNoruSymlink(paths.commands)) {
        fs.unlinkSync(paths.commands);
        log(`  Removed:   ${paths.commands}`);
        removed = true;
      } else {
        log(`  Skipped:   ${paths.commands} (not a noru symlink)`);
      }
    }

    // Remove noru root symlink
    if (fs.existsSync(paths.noruRoot)) {
      try {
        const stat = fs.lstatSync(paths.noruRoot);
        if (stat.isSymbolicLink()) {
          fs.unlinkSync(paths.noruRoot);
          log(`  Removed:   ${paths.noruRoot}`);
          removed = true;
        }
      } catch { /* ignore */ }
    }

    if (removeHooks(paths.hooks)) {
      log(`  Removed:   ${paths.hooks}`);
      removed = true;
    }

    if (removeNoruHookSettings(paths.settings)) {
      log(`  Cleaned:   ${paths.settings}`);
      removed = true;
    }
  }

  if (!removed) {
    log("  Nothing to remove. Noru does not appear to be installed.");
  }

  log("");
}

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

function showHelp() {
  log(`
  noru (NOR-oo) -- from Japanese \u4E57\u308B, to board a route

  Usage:
    npx noru                    Interactive -- ask what to do
    npx noru install            Install globally for Claude Code
    npx noru install --local    Install for current project only
    npx noru uninstall          Remove noru from all locations
    npx noru --help             Show this message
`);
}

async function prompt(question) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.trim());
    });
  });
}

async function interactive() {
  log(`
  noru (NOR-oo) -- from Japanese \u4E57\u308B, to board a route

  What would you like to do?
  1. Install globally (all projects)
  2. Install for this project only
  3. Uninstall
`);

  const answer = await prompt("  Choice [1]: ");
  const choice = answer || "1";

  switch (choice) {
    case "1":
      install(globalPaths());
      break;
    case "2":
      install(localPaths());
      break;
    case "3":
      uninstall();
      break;
    default:
      log(`\n  Unknown choice: ${choice}\n`);
      process.exit(1);
  }
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  const args = process.argv.slice(2);
  const command = args[0];

  if (!command) {
    await interactive();
    return;
  }

  switch (command) {
    case "install": {
      const isLocal = args.includes("--local");
      install(isLocal ? localPaths() : globalPaths());
      break;
    }
    case "uninstall":
      uninstall();
      break;
    case "--help":
    case "-h":
    case "help":
      showHelp();
      break;
    default:
      log(`\n  Unknown command: ${command}`);
      showHelp();
      process.exit(1);
  }
}

main().catch((err) => {
  fail(err.message);
});
