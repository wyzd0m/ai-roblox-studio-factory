# New Game Handoff — paste this into a fresh chat to start a game

**How to use this file:** Open a new Claude Code chat with its working directory set to the factory
(`C:\Users\nicky\Downloads\ai-roblox-studio-factory`), then attach **this file** and your **game
idea `.md`**. Say: *"New game using the factory — here's the handoff and my idea."* That's it.

Everything below is instructions **for Claude** in that new session.

---

## You are working in the AI Roblox Studio Factory

This repo is a factory that turns a one-line game idea into a professional, version-controlled
Roblox game. Read `CLAUDE.md` (the engineering contract) first, then the docs it points to. Do not
re-derive the standards — they're written down.

### What already exists (context)
- **Factory:** `C:\Users\nicky\Downloads\ai-roblox-studio-factory` → GitHub `wyzd0m/ai-roblox-studio-factory` (public).
- **First example game (done):** `C:\Users\nicky\Downloads\Claude-Sandbox` → `wyzd0m/Claude-Woodcutter`
  (chop trees → sell wood). Use it as a reference for the expected shape of a game.
- New games are created as **sibling folders in `C:\Users\nicky\Downloads\`**, named `Claude-<PascalName>`.

### Environment facts (don't re-discover these)
- Windows 11. Shells: PowerShell (primary) + Git Bash. Node.js is installed. Git is installed.
- **`gh` (GitHub CLI) is NOT installed.** GitHub user is **`wyzd0m`** (email dr.nuts1100@gmail.com).
- Rojo is driven via the **VS Code "Rojo" extension (evaera)**; the Roblox Studio Rojo plugin is
  already installed. The human runs the server + connects Studio; you edit files and they sync live.
- Roblox Studio is **not headless** — you cannot playtest. That's the human's job.

### The scope contract (important)
The workflow is **high-automation, human-gated**, not "fully autonomous." You do the game creation;
the human supplies the idea, approves the spec, **playtests**, and **publishes**. Never claim a game
is playtested or "fun" — those are human judgments. Full map: `docs/HUMAN_IN_THE_LOOP.md`.

---

## What to do, in order

1. **Phase 0 — Idea → Spec.** Read the attached idea `.md`. Expand it into a filled
   `templates/GAME_SPEC_TEMPLATE.md` (core loop, systems, win/lose, non-goals, riskiest unknown).
   Ask any clarifying questions. **Then STOP and wait for the human to approve the spec.** Do not
   scaffold or write game code yet.
2. **Scaffold** (after approval): `node scripts/new-game.mjs --name "<Name>" --kind <kind>` →
   creates `..\Claude-<Name>\`. Verify it's created; save the approved spec into the game's
   `docs/GameSpec.md`.
3. **Architecture** (`docs/GAME_ARCHITECTURE.md`): define the contracts first —
   `shared/Net.luau`, `shared/Config.luau`, `shared/Types.luau` — then stop for a quick review.
4. **Build the core loop** server-authoritative, then remaining systems, in **small conventional
   commits**, keeping lint/format/tests/`rojo build` green. Follow `docs/CODING_STANDARDS.md`.
5. **Hand off for playtest** at the natural gate (`docs/DEVELOPMENT_WORKFLOW.md`). The human plays;
   you fix from their notes. The game is "done" when **the human decides it's ready to publish** —
   it may take several rounds.
6. **Release prep** (`standards/RELEASE_CHECKLIST.md`): finalize README/CHANGELOG/docs + YouTube
   metadata, add the game to `games/REGISTRY.md`. The human publishes and uploads.

## Security rules (do not violate)
- **Never ask the human to paste a GitHub token, and never accept one pasted in chat.** To push,
  confirm first, then use `gh` (once installed) or a token the human has placed in an environment
  variable — never write a token into `.git/config`, a commit, or any file.
- **Confirm before creating a remote repo or pushing.** Default new game repos to the human's choice
  of visibility (ask). Publishing to Roblox and uploading to YouTube are **human-only**.

## Your first reply in the new chat should be
The **filled game spec** (from the attached idea) + any clarifying questions, and then a clear
**"approve or adjust before I scaffold?"** — nothing else yet.
