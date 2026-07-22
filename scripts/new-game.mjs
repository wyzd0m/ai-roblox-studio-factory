#!/usr/bin/env node
/**
 * new-game.mjs — scaffold a new Roblox game repo from templates/game-repo/.
 *
 * Deterministic and safe:
 *   - Pure copy + placeholder substitution (no bespoke boilerplate).
 *   - Refuses to overwrite an existing target unless --force.
 *   - Prints exactly what it created.
 *
 * Usage:
 *   node scripts/new-game.mjs --name "Claude Obby" --kind obby [--out ..] [--oneliner "..."] [--force]
 *
 * Produces (default): ../Claude-Obby/  (sibling of the factory)
 *
 * It copies templates/game-repo/, then drops in README.md (from templates/README_TEMPLATE.md)
 * and video/ (from templates/youtube/), substituting {{PLACEHOLDERS}} throughout.
 */

import { promises as fs } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const FACTORY_ROOT = path.resolve(__dirname, "..");

// ---- args -----------------------------------------------------------------
function parseArgs(argv) {
  const args = {};
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a.startsWith("--")) {
      const key = a.slice(2);
      const next = argv[i + 1];
      if (next === undefined || next.startsWith("--")) {
        args[key] = true;
      } else {
        args[key] = next;
        i++;
      }
    }
  }
  return args;
}

function die(msg) {
  console.error(`error: ${msg}`);
  process.exit(1);
}

function toPascal(name) {
  return name
    .replace(/[^A-Za-z0-9]+/g, " ")
    .trim()
    .split(/\s+/)
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join("");
}

// ---- placeholder substitution ---------------------------------------------
function substitute(text, vars) {
  return text.replace(/\{\{([A-Z_]+)\}\}/g, (match, key) =>
    key in vars ? vars[key] : match,
  );
}

// Only substitute inside text files; copy others (none expected in template) byte-for-byte.
const TEXT_EXT = new Set([
  ".md", ".luau", ".lua", ".json", ".toml", ".yml", ".yaml", ".txt", ".gitignore", "",
]);

async function copyTree(srcDir, destDir, vars, created) {
  await fs.mkdir(destDir, { recursive: true });
  const entries = await fs.readdir(srcDir, { withFileTypes: true });
  for (const entry of entries) {
    const srcPath = path.join(srcDir, entry.name);
    // Substitute placeholders in file/dir names too (e.g. none today, but future-proof).
    const destName = substitute(entry.name, vars);
    const destPath = path.join(destDir, destName);
    if (entry.isDirectory()) {
      await copyTree(srcPath, destPath, vars, created);
    } else {
      const ext = path.extname(entry.name);
      if (TEXT_EXT.has(ext) || entry.name.startsWith(".")) {
        const raw = await fs.readFile(srcPath, "utf8");
        await fs.writeFile(destPath, substitute(raw, vars), "utf8");
      } else {
        await fs.copyFile(srcPath, destPath);
      }
      created.push(path.relative(process.cwd(), destPath));
    }
  }
}

async function exists(p) {
  try {
    await fs.access(p);
    return true;
  } catch {
    return false;
  }
}

// ---- main -----------------------------------------------------------------
async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (!args.name) die('missing --name (e.g. --name "Claude Obby")');
  const kind = args.kind || "game";

  const pascal = toPascal(String(args.name)); // "Claude Obby" -> "ClaudeObby"
  // Repo slug is always "Claude-<PascalName>", collapsing a leading "Claude" so we don't double it.
  const slugFinal = pascal.startsWith("Claude")
    ? `Claude-${pascal.slice("Claude".length)}`
    : `Claude-${pascal}`;

  const now = new Date();
  const vars = {
    GAME_NAME: String(args.name),
    GAME_SLUG: slugFinal,
    GAME_SLUG_LOWER: slugFinal.toLowerCase(),
    GAME_KIND: String(kind),
    ONE_LINER: args.oneliner ? String(args.oneliner) : "<one-liner — fill from the spec>",
    YEAR: String(now.getFullYear()),
    DATE: now.toISOString().slice(0, 10),
  };

  const outBase = args.out ? path.resolve(String(args.out)) : path.resolve(FACTORY_ROOT, "..");
  const destDir = path.join(outBase, vars.GAME_SLUG);

  if ((await exists(destDir)) && !args.force) {
    die(`target already exists: ${destDir} (use --force to overwrite)`);
  }

  const created = [];
  const templateRoot = path.join(FACTORY_ROOT, "templates", "game-repo");

  // 1) copy the scaffold
  await copyTree(templateRoot, destDir, vars, created);

  // 2) README from the canonical template
  const readmeSrc = path.join(FACTORY_ROOT, "templates", "README_TEMPLATE.md");
  const readmeRaw = await fs.readFile(readmeSrc, "utf8");
  await fs.writeFile(path.join(destDir, "README.md"), substitute(readmeRaw, vars), "utf8");
  created.push(path.relative(process.cwd(), path.join(destDir, "README.md")));

  // 3) YouTube metadata into video/
  const ytSrc = path.join(FACTORY_ROOT, "templates", "youtube");
  await copyTree(ytSrc, path.join(destDir, "video"), vars, created);

  // 4) empty assets/ with a provenance note
  await fs.mkdir(path.join(destDir, "assets"), { recursive: true });
  await fs.writeFile(
    path.join(destDir, "assets", "PROVENANCE.md"),
    `# Asset Provenance — ${vars.GAME_NAME}\n\nList every non-procedural asset, its source, and its license here.\nPlaceholder-first: prefer Roblox primitives / procedural geometry.\n`,
    "utf8",
  );
  created.push(path.relative(process.cwd(), path.join(destDir, "assets", "PROVENANCE.md")));

  console.log(`\nScaffolded ${vars.GAME_NAME} → ${destDir}`);
  console.log(`  slug: ${vars.GAME_SLUG}   kind: ${vars.GAME_KIND}`);
  console.log(`  files created: ${created.length}`);
  console.log(`\nNext:`);
  console.log(`  cd ${path.relative(process.cwd(), destDir)}`);
  console.log(`  git init && rokit install && rojo build -o build.rbxl`);
  console.log(`  # then implement per docs/GAME_ARCHITECTURE.md, and add a row to games/REGISTRY.md\n`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
