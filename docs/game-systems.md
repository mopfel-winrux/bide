# Game Systems

## XP & Leveling

Bide uses the standard RuneScape XP curve. The table in `lib/bide-xp.hoon` maps 99 levels, from 0 XP (level 1) to 13,034,431 XP (level 99). `++level-from-xp` walks the table top-down to find the current level.

The same table is duplicated client-side in `ui/src/shared/xp.ts` so the frontend can compute levels for optimistic display without waiting for a server poll.

## Skills

There are two skill types implemented:

**Gathering** — produce items from nothing. The player selects an action; each tick that completes the action's `base-time` awards XP and deposits output items into the bank.
- Woodcutting (9 trees, level 1-90)
- Fishing (12 catches including vials, level 1-90)
- Mining (12 rocks including rune essence and onyx, level 1-90)
- Thieving (9 NPCs, level 1-90, produces GP pouches + herbs)

**Artisan** — consume input items to produce output items. If the bank runs out of inputs, the action stops automatically.
- Firemaking (9 log types → charcoal, level 1-90)
- Cooking (11 raw fish → cooked fish, level 1-90)
- Smithing (9 smelting recipes, ores + coal → bars, level 1-80)
- Fletching (14 recipes, logs → shortbows/longbows, level 1-95)
- Crafting (14 recipes, bars → helmets/platebodies, level 1-93)
- Runecrafting (10 rune types, rune essence → runes, level 1-95)
- Herblore (8 potions, herbs + vials → potions, level 1-90)

## Action Timing

Each action has a `base-time` in milliseconds. The agent's 1-second Behn timer calls `++process-tick`, which calculates elapsed time since `started` and determines how many actions completed: `num-actions = elapsed / base-dr`. Leftover time carries forward. This means actions complete at their true rate regardless of tick granularity.

## Bank

The bank is a simple `(map item-id @ud)` — item ID to quantity. There's a `slots-max` field (initialized to 12) limiting unique item types, though it's not currently enforced in the tick logic.

**Selling.** POST `/sell/<item>/<qty>` sells up to `qty` of an item for `sell-price * qty` GP. POST `/sell-all/<item>` sells the entire stack. Items at 0 quantity are removed from the map.

## Item Categories

Items are tagged with one of 8 categories defined in `sur/bide.hoon`:
- `%raw-material` — logs, ore, fish, herbs, rune essence
- `%processed` — bars
- `%equipment` — weapons, armor, bows
- `%food` — cooked fish
- `%gem` — onyx
- `%rune` — crafted runes
- `%potion` — brewed potions
- `%misc` — GP pouches, vials

## Mastery

Each action awards mastery XP (defined per action in `bide-skills.hoon`). Mastery is tracked per-action in `actions=(map action-id @ud)` inside `mastery-state`. A pool XP value also accumulates at 25% of the per-action mastery gain. Mastery unlocks are not yet implemented but the data is tracked and ready.

## Optimistic UI

The frontend shows XP drops and item gains immediately without waiting for the next poll. `useGameState.ts` maintains `pendingXPRef` and `pendingItemsRef` refs. When a poll confirms server-side progress, the delta is subtracted from pending values. `getDisplaySkill()` and `getDisplayBank()` merge server state with pending for display. This gives the player instant feedback while staying reconciled with the authoritative server state.

## Level-Up Toasts

The poll loop in `useGameState.ts` compares previous and current skill levels. When `curSkill.level > prevSkill.level`, a toast notification is queued via `setLevelUps`. The UI displays and auto-dismisses these.
