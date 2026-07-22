# Prompt Template — kicking off a game

Paste this into Claude to start a new game. Fill the idea; leave the rest — the factory docs supply
the standards.

---

**Build a Roblox game using the AI Roblox Studio Factory conventions.**

**Idea:** <one sentence — e.g. "A speedrun obby where touching lava resets you to the last
checkpoint and your best time is saved.">

**Kind:** <obby | tycoon | simulator | horror | tower-defense | racing | other>

**Instructions:**
1. Follow the factory contract in `CLAUDE.md` and the phase gates in
   `docs/DEVELOPMENT_WORKFLOW.md`. Do not build the whole game in one pass.
2. **Phase 0 first:** expand my idea into a filled `templates/GAME_SPEC_TEMPLATE.md` and stop for
   my review. Do not scaffold until I approve the spec.
3. After approval, scaffold with `scripts/new-game.mjs`, then implement per
   `docs/GAME_ARCHITECTURE.md` in small conventional commits.
4. Keep CI green (Selene, StyLua, tests, `rojo build`) throughout.
5. Stop at the human gates in `docs/HUMAN_IN_THE_LOOP.md` — do not attempt to playtest, publish, or
   upload. Prepare artifacts and hand off.
6. Be honest about anything you can't verify (fun, in-Studio behavior). Never imply the game is
   playtested when it hasn't been.

**Constraints:** <budget, deadline, art limits, or "none — use factory defaults">

---

### Follow-up prompt to resume mid-build
> Continue <GAME_NAME> from Phase <N>. Report what changed, run the gates, and stop at the next
> review gate.
