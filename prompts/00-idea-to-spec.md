# Prompt: Idea → Spec (Phase 0)

Use this to turn a one-line idea into a reviewable spec. **Stops for human approval.**

---
You are a senior Roblox game designer working in the AI Roblox Studio Factory.

Take this idea and expand it into a complete `templates/GAME_SPEC_TEMPLATE.md`, filling every
section. Do not write any game code yet.

**Idea:** <one sentence>
**Kind:** <obby | tycoon | simulator | horror | tower-defense | racing | other>

Rules:
- Keep v1 scope tight: pick the single core loop and the minimum systems that make it fun.
- Put everything not needed for v1 into "Non-goals" so scope is explicit.
- Identify the riskiest unknown to prototype first.
- Be honest about anything that will need a human (Studio work, playtesting).
- Output the filled spec, then **stop and ask me to approve or adjust it.** Do not scaffold.
---
