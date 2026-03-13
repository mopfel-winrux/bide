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
- `/equip/<item>` — equip an item
- `/unequip/<slot>` — unequip a slot
- `/fight/<area>/<monster>/<style>` — start combat
- `/flee` — stop combat
- `/set-auto-eat/<threshold>/<food>` — configure auto-eat
- `/drink-potion/<item>` — drink a potion (instant effects work outside combat; boost potions require combat)
- `/toggle-prayer/<prayer>` — toggle a prayer on/off
- `/special-attack` — queue a special attack
- `/get-slayer-task` — request a slayer task
- `/start-dungeon/<dungeon>/<style>` — enter a dungeon
- `/plant-seed/<plot>/<seed>` — plant a seed in a farm plot
- `/harvest-plot/<plot>` — harvest a ready farm plot
- `/summon-familiar/<tablet>` — summon a familiar from a tablet
- `/dismiss-familiar` — dismiss active familiar
- `/eat-food/<item>` — eat food from bank to heal HP

**Scry.** The same data is available via scry at `/x/state` and `/x/defs`.

**State versioning.** Agent state is `state-0` inside a `versioned-state` tagged union in `lib/bide-state.hoon`, ready for future migrations in `++on-load`.

**Debug poke.** A `%noun` poke accepts either a raw `game-state` noun (overwrites entire state) or the atom `%test-setup` (injects high-level passive skills and seeds/tablets into the bank for testing). Used with the MCP `poke-our-agent` tool.

## Frontend — React + Vite

The UI lives in `ui/` and is a single-page app using React Router.

**Polling.** `useGameState.ts` fetches `/defs` once on mount, then polls `/state` every 1 second. There are no subscriptions — pure HTTP polling.

**Optimistic updates.** Between polls, the hook tracks `pendingXPRef` and `pendingItemsRef`. When a new poll arrives, confirmed server deltas are subtracted from pending values, preventing double-counting. `getDisplaySkill()` and `getDisplayBank()` merge server + pending for smooth UI.

**Level-up detection.** The poll loop compares `prev.skills[sid].level` to `cur.skills[sid].level` and fires toast notifications on change.

**Routing.** `App.tsx` wraps everything in `<GameProvider>` and uses:
- `/` — OverviewPage (skill summary grid)
- `/skill/:skillId` — SkillPage (action list, XP bar, start/stop, skill-specific bonus panels)
- `/bank` — BankPage (items, sell/eat/drink buttons)
- `/combat` — CombatPage (areas, dungeons, prayers, fight controls)
- `/equipment` — EquipmentPage (gear slots, equip/unequip, familiar management)
- `/farming` — FarmingPage (farm plot grid, seed selection, timers)
- `*` — NotFoundPage

`/skill/farming` redirects to `/farming`.

## Data-Driven Engine

Skills and items are pure data — no engine changes needed to add content.

- `lib/bide-skills.hoon` — `++skill-registry` returns `(map skill-id skill-def)`. Each skill has a list of `action-def` with level requirements, XP, base time (ms), input items, output items, and mastery XP.
- `lib/bide-items.hoon` — `++item-registry` returns `(map item-id item-def)`. Each item has a name, category, and sell price.
- `sur/bide.hoon` — All type definitions: `game-state`, `skill-def`, `action-def`, `item-def`, `item-category`, `action`, `update`, combat types, prayer/potion/dungeon types.
- `lib/bide-xp.hoon` — Hardcoded 99-level XP table and `++level-from-xp` / `++xp-for-level` / `++xp-to-next` gates.
- `lib/bide-monsters.hoon` — `++monster-registry` returns `(map monster-id monster-def)`. 13 monsters with combat stats, attack speed, loot tables.
- `lib/bide-areas.hoon` — `++area-registry` returns `(map area-id area-def)`. 6 areas with level requirements and monster lists.
- `lib/bide-equipment.hoon` — `++equipment-stats-registry` returns equipment stat bonuses for all gear items.
- `lib/bide-combat.hoon` — Combat engine: hit calculations, damage rolls, effective levels with boost/prayer integration.
- `lib/bide-potions.hoon` — 8 potion definitions, boost computation, potion tick-down logic.
- `lib/bide-prayers.hoon` — 8 prayer definitions, prayer bonus aggregation, drain calculation.
- `lib/bide-specials.hoon` — 4 special attack definitions mapped to specific weapons.
- `lib/bide-slayer.hoon` — Slayer task assignment tables by level range.
- `lib/bide-dungeons.hoon` — 3 dungeon definitions with room sequences and reward tables.
- `lib/bide-food.hoon` — Food healing values for auto-eat and eat-from-bank.
- `lib/bide-farming.hoon` — Seed registry, max-plots calculation, plot helpers.
- `lib/bide-agility.hoon` — Agility milestone bonuses (XP, speed, farming yield, combat XP).
- `lib/bide-astrology.hoon` — Constellation registry, mastery-based and global level XP bonuses.
- `lib/bide-summoning.hoon` — Familiar registry, XP/combat/farming bonuses, charge management.
- `lib/bide-state.hoon` — Agent state types (`state-0`, `versioned-state`).

## Key Files

| File | Purpose |
|------|---------|
| `app/bide.hoon` | Gall agent — HTTP handler, timer loop, game tick engine, combat processing |
| `sur/bide.hoon` | Type definitions (game state, combat, prayers, potions, dungeons, all actions) |
| `lib/bide-state.hoon` | Agent state versioning (`state-0`, `versioned-state`) |
| `lib/bide-skills.hoon` | Skill and action data definitions (15 skills) |
| `lib/bide-items.hoon` | Item data definitions (~150 items) |
| `lib/bide-xp.hoon` | XP table and level calculation |
| `lib/bide-monsters.hoon` | Monster definitions (13 monsters) |
| `lib/bide-areas.hoon` | Combat area definitions (6 areas) |
| `lib/bide-equipment.hoon` | Equipment stat bonuses |
| `lib/bide-combat.hoon` | Combat math — hit chance, damage, effective levels |
| `lib/bide-food.hoon` | Food healing values (auto-eat + bank eating) |
| `lib/bide-farming.hoon` | Seed registry, plot helpers (15 seeds) |
| `lib/bide-agility.hoon` | Agility milestone bonus functions |
| `lib/bide-astrology.hoon` | Constellation registry, mastery XP bonuses |
| `lib/bide-summoning.hoon` | Familiar registry, charge management (8 familiars) |
| `lib/bide-potions.hoon` | Potion effect registry (8 potions) |
| `lib/bide-prayers.hoon` | Prayer definitions and bonus computation (8 prayers) |
| `lib/bide-specials.hoon` | Special attack registry (4 weapon specials) |
| `lib/bide-slayer.hoon` | Slayer task assignment tables |
| `lib/bide-dungeons.hoon` | Dungeon definitions (3 dungeons) |
| `ui/src/App.tsx` | React router and layout shell |
| `ui/src/context/GameContext.tsx` | Game state provider, polling, API method wrappers |
| `ui/src/pages/OverviewPage.tsx` | Skill summary grid |
| `ui/src/pages/SkillPage.tsx` | Per-skill action list and controls |
| `ui/src/pages/BankPage.tsx` | Inventory and sell interface |
| `ui/src/pages/CombatPage.tsx` | Combat — area/dungeon selection, prayers, fight controls |
| `ui/src/pages/EquipmentPage.tsx` | Equipment management, familiar summon/dismiss |
| `ui/src/pages/FarmingPage.tsx` | Farm plot grid, seed selection, growth timers |
| `ui/src/components/SkillBonuses.tsx` | Agility milestones, astrology bonuses, summoning familiar effects |
| `ui/src/components/CombatPanel.tsx` | Active combat UI — HP bars, timers, potions, prayers, specials |
| `ui/src/components/MonsterCard.tsx` | Monster stat display card |
| `ui/src/components/CombatStyleSelector.tsx` | Melee/ranged/magic style picker |
| `ui/src/shared/types.ts` | TypeScript type definitions |
| `ui/src/shared/api.ts` | HTTP API client |
| `ui/src/shared/xp.ts` | Client-side XP table (mirrors Hoon) |
