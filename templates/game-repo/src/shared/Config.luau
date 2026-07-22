--!strict
-- Server-trusted tunables. Keep gameplay-affecting constants here (read server-side) so the
-- client cannot forge them. Client may read cosmetic values only.
local Config = {
    GAME_NAME = "{{GAME_NAME}}",

    -- Example tunables — replace per game spec.
    CORE_ACTION_COOLDOWN = 0.5, -- seconds; server-enforced rate limit
    STARTING_SCORE = 0,
    MAX_SCORE = 1_000_000,
}

return Config
