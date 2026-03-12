# Architecture

Bide is a Melvor Idle-style RPG running on Urbit. The backend is a Gall agent written in Hoon; the frontend is a React SPA.

## Backend — Gall Agent

`app/bide.hoon` is the core agent. It uses the `=<` pattern: a standard 10-arm agent door sits above a helper core that contains all game logic.

**Timer loop.** On `++on-init`, the agent binds to Eyre at `/apps/bide/api` and starts a 1-second Behn timer on wire `/timer/tick`. Each `++on-arvo` wake calls `++process-tick`, which advances the active action, awards XP, produces/consumes items, then re-arms the timer.

**HTTP API.** Eyre HTTP requests arrive as `%handle-http-request` pokes. GET endpoints:
- `/state` — full game state as JSON (player GP/HP, all skills, bank, active action)
- `/defs` — static definitions (every skill, action, and item)

POST endpoints:
- `/start/<skill>/<action>` — begin skilling
- `/stop` — stop current action
- `/sell/<item>/<qty>` — sell items for GP
- `/sell-all/<item>` — sell entire stack

**Scry.** The same data is available via scry at `/x/state` and `/x/defs`.

**State versioning.** Agent state is `state-0` inside a `versioned-state` tagged union, ready for future migrations in `++on-load`.

## Frontend — React + Vite

The UI lives in `ui/` and is a single-page app using React Router.

**Polling.** `useGameState.ts` fetches `/defs` once on mount, then polls `/state` every 1 second. There are no subscriptions — pure HTTP polling.

**Optimistic updates.** Between polls, the hook tracks `pendingXPRef` and `pendingItemsRef`. When a new poll arrives, confirmed server deltas are subtracted from pending values, preventing double-counting. `getDisplaySkill()` and `getDisplayBank()` merge server + pending for smooth UI.

**Level-up detection.** The poll loop compares `prev.skills[sid].level` to `cur.skills[sid].level` and fires toast notifications on change.

**Routing.** `App.tsx` wraps everything in `<GameProvider>` and uses:
- `/` — OverviewPage (skill summary grid)
- `/skill/:skillId` — SkillPage (action list, XP bar, start/stop)
- `/bank` — BankPage (items, sell buttons)
- `*` — NotFoundPage

## Data-Driven Engine

Skills and items are pure data — no engine changes needed to add content.

- `lib/bide-skills.hoon` — `++skill-registry` returns `(map skill-id skill-def)`. Each skill has a list of `action-def` with level requirements, XP, base time (ms), input items, output items, and mastery XP.
- `lib/bide-items.hoon` — `++item-registry` returns `(map item-id item-def)`. Each item has a name, category, and sell price.
- `sur/bide.hoon` — All type definitions: `game-state`, `skill-def`, `action-def`, `item-def`, `item-category`, `action`, `update`.
- `lib/bide-xp.hoon` — Hardcoded 99-level XP table and `++level-from-xp` / `++xp-for-level` / `++xp-to-next` gates.

## Key Files

| File | Purpose |
|------|---------|
| `app/bide.hoon` | Gall agent — HTTP handler, timer loop, game tick engine |
| `sur/bide.hoon` | Type definitions (game state, actions, items, updates) |
| `lib/bide-skills.hoon` | Skill and action data definitions (11 skills) |
| `lib/bide-items.hoon` | Item data definitions (~120 items) |
| `lib/bide-xp.hoon` | XP table and level calculation |
| `ui/src/App.tsx` | React router and layout shell |
| `ui/src/hooks/useGameState.ts` | Polling, optimistic updates, level-up detection |
| `ui/src/pages/OverviewPage.tsx` | Skill summary grid |
| `ui/src/pages/SkillPage.tsx` | Per-skill action list and controls |
| `ui/src/pages/BankPage.tsx` | Inventory and sell interface |
| `ui/src/shared/types.ts` | TypeScript type definitions |
| `ui/src/shared/api.ts` | HTTP API client |
| `ui/src/shared/xp.ts` | Client-side XP table (mirrors Hoon) |
