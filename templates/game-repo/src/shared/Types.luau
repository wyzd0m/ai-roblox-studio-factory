--!strict
-- Shared type definitions. Import these instead of re-declaring shapes across modules.

export type PlayerState = {
    score: number,
    lastActionAt: number, -- os.clock() timestamp for rate limiting
}

export type CoreActionResult = {
    ok: boolean,
    reason: string?, -- populated when ok == false
    score: number?,
}

return {}
