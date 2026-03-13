# Game Systems

## XP & Leveling

Bide uses the standard RuneScape XP curve. The table in `lib/bide-xp.hoon` maps 99 levels, from 0 XP (level 1) to 13,034,431 XP (level 99). `++level-from-xp` walks the table top-down to find the current level.

The same table is duplicated client-side in `ui/src/shared/xp.ts` so the frontend can compute levels for optimistic display without waiting for a server poll.

## Skills

There are four skill types implemented:

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

**Combat** — leveled by fighting monsters. XP awarded per kill based on damage dealt.
- Attack (melee accuracy, leveled via melee-attack style)
- Strength (melee max hit, leveled via melee-strength style)
- Defence (damage mitigation, leveled via melee-defence style)
- Hitpoints (health pool, always gains XP in combat)
- Ranged (ranged accuracy + damage, leveled with ranged weapons)
- Magic (magic accuracy + damage, leveled with magic weapons)

**Passive** — leveled through non-combat activities, provides combat benefits.
- Prayer (unlocks combat prayers, leveled via slayer tasks)
- Slayer (unlocks slayer-only monsters, leveled via task kills)

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

## Combat

Combat uses two independent Behn timers — one for the player attack and one for the enemy attack. Each timer fires on its own wire (`/timer/player-atk`, `/timer/enemy-atk`), and `++on-arvo` dispatches to `process-combat-events` or `process-dungeon-events` accordingly.

**Hit calculation.** `lib/bide-combat.hoon` computes effective attack/strength/defence levels from base skill level + potion boosts + prayer boosts. Hit chance uses an attack roll vs defence roll comparison. Damage is rolled 0 to max hit (based on effective strength). PRNG uses a seed stored in `game-state` and advanced each roll.

**Combat styles.** Three weapon types (melee, ranged, magic) with sub-styles. Melee has attack/strength/defence variants that direct XP to different skills. The frontend auto-selects a valid style when the equipped weapon type changes.

**Food & auto-eat.** Players configure a food item and HP threshold. Each combat tick checks if HP is below threshold and auto-consumes food from the bank. Food healing values are defined in `lib/bide-food.hoon`.

**Monotonic attack counters.** Each combat action tracks `playerAtkCount` and `enemyAtkCount`. The frontend detects increments to trigger damage splat animations and reset attack timer bars, avoiding issues with polling granularity.

## Equipment

Four equipment slots: helmet, platebody, weapon, shield. Each equipped item provides stat bonuses defined in `lib/bide-equipment.hoon`: attack/strength/defence bonuses for melee, ranged, and magic, plus attack speed for weapons. Equipping/unequipping moves items between bank and equipment slots.

## Potions

8 potions brewed via Herblore, consumed during combat from the bank. Three types of effects:

- **Timed boosts** (attack/strength/defence): +10% or +15% for 50 player attacks. Multiple potions stack by taking the max of each boost type.
- **Instant heal**: Hitpoints potion restores 150 HP immediately.
- **Prayer restore**: Prayer potion restores 30 prayer points immediately.

Active potion effects are tracked in `game-state.active-potions`. Each player attack decrements `turns-left`; expired effects are removed. `compute-boosts` in `lib/bide-potions.hoon` aggregates the max boost percentage for each stat from all active effects.

## Prayers

8 prayers unlocked by prayer level (1-43). Prayers are toggled on/off and remain active during combat.

| Prayer | Level | Effect | Drain/atk |
|--------|-------|--------|-----------|
| Thick Skin | 1 | +5% defence | 1 |
| Burst of Strength | 4 | +5% strength | 1 |
| Clarity of Thought | 7 | +5% attack | 1 |
| Superhuman Strength | 13 | +10% strength | 2 |
| Improved Reflexes | 16 | +10% attack | 2 |
| Protect from Melee | 37 | -40% melee damage | 4 |
| Protect from Ranged | 40 | -40% ranged damage | 4 |
| Protect from Magic | 43 | -40% magic damage | 4 |

Prayer points drain per player attack based on the sum of all active prayer drain rates. When points hit 0, all prayers auto-deactivate. Points are restored with prayer potions. Max prayer points = prayer level × 10.

## Special Attacks

Certain weapons have special attacks with an energy cost, damage multiplier, and accuracy multiplier. Energy accumulates at +10 per player attack (capped at 100). The player queues a special; the next attack applies the multipliers.

| Weapon | Special | Energy | Damage | Accuracy |
|--------|---------|--------|--------|----------|
| Maple Shortbow | Quick Shot | 25% | 1.15x | 1.15x |
| Yew Longbow | Power Shot | 50% | 1.5x | 0.9x |
| Magic Shortbow | Rapid Fire | 50% | 1.3x | 1.2x |
| Redwood Longbow | Annihilate | 100% | 2.0x | 0.8x |

## Slayer

The slayer master assigns a task: kill N of a specific monster. Tasks are gated by slayer level — higher level unlocks harder monsters. The task tracks `qty-remaining` and `qty-total`. Players can only have one active task at a time.

The slayer task table in `lib/bide-slayer.hoon` maps level ranges to eligible monsters with kill count ranges. Task assignment uses the PRNG to pick from eligible monsters.

## Dungeons

Dungeons are multi-room encounters. Each room has a monster type and kill count. The player auto-fights through rooms sequentially. On clearing the final room, reward loot is rolled from the dungeon's reward table.

| Dungeon | Level | Rooms |
|---------|-------|-------|
| Goblin Lair | 10 | Goblin ×5 → Zombie ×3 → Skeleton ×1 |
| Dark Fortress | 40 | Bandit ×5 → Dark Knight ×3 → Cave Troll ×2 → Ogre ×1 |
| Dragons Den | 80 | Fire Giant ×3 → Demon ×2 → Dragon ×1 |

Dungeon state tracks room index and room kills separately. The combat panel shows room progress during a dungeon run. All combat mechanics (potions, prayers, specials, auto-eat) work inside dungeons.
