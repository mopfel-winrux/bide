# Game Systems

## XP & Leveling

Bide uses the standard RuneScape XP curve. The table in `lib/bide-xp.hoon` maps 99 levels, from 0 XP (level 1) to 13,034,431 XP (level 99). `++level-from-xp` walks the table top-down to find the current level.

The same table is duplicated client-side in `ui/src/shared/xp.ts` so the frontend can compute levels for optimistic display without waiting for a server poll.

**XP per action is calibrated to Melvor Idle values.** For example, cutting a normal tree gives 10 XP (not 100), fishing shrimp gives 5 XP (6s), mining copper gives 7 XP (5s). Action times also match Melvor where applicable (e.g., high-tier mining is very slow: runite 60s, dragonite 120s). Combat XP per kill ≈ monster HP × 0.4.

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

**Passive** — provide on-the-fly bonuses to other skills and combat.
- Prayer (unlocks combat prayers, leveled via slayer tasks)
- Slayer (unlocks slayer-only monsters, leveled via task kills)
- Farming (plant seeds in plots, harvest crops after growth timer; 15 seeds, 2-8 plots by level)
- Agility (10 obstacle courses; milestones grant XP bonuses, speed bonuses, farming yield)
- Astrology (12 constellations linked to skills; mastery-based XP bonuses per constellation, global level bonuses)
- Summoning (craft 8 tablet types from charcoal + materials; summon familiars for XP/combat/farming bonuses)

## Action Timing

Each action has a `base-time` in milliseconds. The agent's 1-second Behn timer calls `++process-tick`, which calculates elapsed time since `started` and determines how many actions completed: `num-actions = elapsed / base-dr`. Leftover time carries forward. This means actions complete at their true rate regardless of tick granularity.

## Bank

The bank is a simple `(map item-id @ud)` — item ID to quantity. There's a `slots-max` field (initialized to 12) limiting unique item types, though it's not currently enforced in the tick logic.

**Selling.** POST `/sell/<item>/<qty>` sells up to `qty` of an item for `sell-price * qty` GP. POST `/sell-all/<item>` sells the entire stack. Items at 0 quantity are removed from the map.

## Item Categories

Items are tagged with one of 10 categories defined in `sur/bide.hoon`:
- `%raw-material` — logs, ore, fish, herbs, rune essence
- `%processed` — bars
- `%equipment` — weapons, armor, bows
- `%food` — cooked fish, farming crops
- `%gem` — onyx
- `%rune` — crafted runes
- `%potion` — brewed potions
- `%seed` — farming seeds
- `%tablet` — summoning tablets
- `%misc` — GP pouches, vials

## Mastery

Each action awards mastery XP (defined per action in `bide-skills.hoon`). Mastery is tracked per-action in `actions=(map action-id @ud)` inside `mastery-state`. A pool XP value also accumulates at 25% of the per-action mastery gain. Mastery unlocks are not yet implemented but the data is tracked and ready.

## Optimistic UI

The frontend shows XP drops and item gains immediately without waiting for the next poll. `useGameState.ts` maintains `pendingXPRef` and `pendingItemsRef` refs. When a poll confirms server-side progress, the delta is subtracted from pending values. `getDisplaySkill()` and `getDisplayBank()` merge server state with pending for display. This gives the player instant feedback while staying reconciled with the authoritative server state.

## Level-Up Toasts

The poll loop in `useGameState.ts` compares previous and current skill levels. When `curSkill.level > prevSkill.level`, a toast notification is queued via `setLevelUps`. The UI displays and auto-dismisses these.

## Welcome Back Summary

When the player returns after being away >30 seconds, a modal shows what happened while they were offline: GP earned, XP gained per skill, level-ups, monsters killed, items gained/consumed, dungeons completed, and new pets found.

**Implementation:** Frontend-only, zero backend changes. On every state poll, `useGameState.ts` saves a lightweight snapshot (GP, skills, bank, stats, pets) to localStorage. On fresh page load, it compares the stored snapshot to the first polled state. If away >30s and something meaningful changed (xpEarned > 0, etc.), the diff is shown in `WelcomeBackModal`. Negative XP delta (state nuked) is treated as no meaningful change.

## Output Chance Rolls

Skill action outputs have a `chance` field (0-100). The `process-skill-tick` engine rolls each output using the `og` PRNG door seeded with `eny.bowl` (kernel entropy). For batch processing (multiple actions completed while idle), the engine computes `(num_actions × chance) / 100` guaranteed drops plus a random roll for the fractional remainder. Only guaranteed drops (chance=100) are shown in the frontend's optimistic XP drop animation; chance-based items appear when the next server poll confirms them.

## Combat

Combat uses two independent Behn timers — one for the player attack and one for the enemy attack. Each timer fires on its own wire (`/timer/player-atk`, `/timer/enemy-atk`), and `++on-arvo` dispatches to `process-combat-events` or `process-dungeon-events` accordingly.

**Hit calculation.** `lib/bide-combat.hoon` computes effective attack/strength/defence levels from base skill level + potion boosts + prayer boosts. Hit chance uses an attack roll vs defence roll comparison. Damage is rolled 0 to max hit (based on effective strength). PRNG uses the `og` door from Hoon stdlib, seeded by mixing the stored `rng-seed` with `eny.bowl` (kernel entropy) at the start of each combat event.

**Combat styles.** Three weapon types (melee, ranged, magic) with sub-styles. Melee has attack/strength/defence variants that direct XP to different skills. The frontend auto-selects a valid style when the equipped weapon type changes. Magic is always available as a combat style — with a magic weapon it uses equipment stats; with a spell selected it uses spell-based combat (fixed max hit from spell, accuracy from magic level, runes consumed per attack).

**Food & auto-eat.** Players configure a food item and HP threshold. Each combat tick checks if HP is below threshold and auto-consumes food from the bank. Food healing values are defined in `lib/bide-food.hoon`.

**Monotonic attack counters.** Each combat action tracks `playerAtkCount` and `enemyAtkCount`. The frontend detects increments to trigger damage splat animations and reset attack timer bars, avoiding issues with polling granularity.

## Equipment

Four equipment slots: helmet, platebody, weapon, shield. Each equipped item provides stat bonuses defined in `lib/bide-equipment.hoon`: attack/strength/defence bonuses for melee, ranged, and magic, plus attack speed for weapons. Equipping/unequipping moves items between bank and equipment slots.

## Potions

8 potions brewed via Herblore, consumed from the bank. Three types of effects:

- **Timed boosts** (attack/strength/defence): +10% or +15% for 50 player attacks. Multiple potions stack by taking the max of each boost type. **Requires active combat.**
- **Instant heal**: Hitpoints potion restores 150 HP immediately. **Works outside combat.**
- **Prayer restore**: Prayer potion restores 30 prayer points immediately. **Works outside combat.**

Active potion effects are tracked in `game-state.active-potions`. Each player attack decrements `turns-left`; expired effects are removed. `compute-boosts` in `lib/bide-potions.hoon` aggregates the max boost percentage for each stat from all active effects.

## Food

Food can be eaten from the bank to heal HP outside combat via the `%eat-food` action. Healing values are defined in `lib/bide-food.hoon`. During combat, food is consumed automatically via the auto-eat system when HP drops below the configured threshold. Farming crops (potato through snape-grass) heal 20-200 HP; cooked fish heal 30-320 HP.

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

## Farming

Players plant seeds in farm plots. Each seed has a level requirement, growth time (real-time), XP reward, and crop yield range. Plots are unlocked by farming level: 2 at level 1, +1 at levels 15, 30, 50, 70, 85 (max 8).

**Seed types:**
- **Allotment** (7 seeds): potato through snape-grass, levels 1-61, growth 2-60 min, yield 3-5 food items
- **Herb** (8+4 seeds): guam through torstol plus avantoe/lantadyme/cadantine/snapdragon, levels 9-80, growth 3-120 min, yield 1-3 grimy herbs

Seeds are obtained from thieving NPC drops (10-15% chance). Crops harvested from allotments double as food with healing values 20-200 HP.

**XP = base XP per seed × final yield.** Harvesting 3 potatoes at 8 XP each gives 24 XP. Yield is computed with RNG (using the `og` door) between min/max, plus percentage bonuses from agility (farming yield at level 70), astrology (constellation mastery), and active familiar effects.

## Agility

A gathering-type skill with 10 obstacle courses (pure XP actions, no items). Provides passive milestone bonuses computed on-the-fly from agility level:

| Level | Bonus |
|-------|-------|
| 10 | +2% Woodcutting XP |
| 20 | +2% Mining XP |
| 30 | +2% Fishing XP |
| 40 | +3% Thieving XP |
| 50 | -5% action time (all gathering/artisan) |
| 60 | +3% Combat XP |
| 70 | +5% Farming Yield |
| 80 | -5% more action time (stacks to -10%) |
| 90 | +5% all skill XP |

Bonuses are applied in `process-skill-tick` (speed and XP) and `process-combat-events` (combat XP on kill).

## Astrology

A gathering-type skill with 12 constellations, each linked to a different skill (woodcutting, mining, fishing, firemaking, cooking, thieving, smithing, herblore, farming, fletching, attack, defence).

**Global level bonuses** (applied to all XP):
- Level 25: +1%, Level 50: +3%, Level 75: +4%, Level 99: +6%

**Per-constellation mastery bonuses** (applied to the linked skill's XP):
- 100 mastery XP: +1%, 500 mastery XP: +3%, 2,000 mastery XP: +6%

## Summoning

An artisan-type skill with 8 tablet recipes. Each tablet requires charcoal plus skill-specific materials. Summoning a familiar consumes one tablet from the bank and sets the active familiar state.

**Familiar effects:**

| Familiar | Charges | Effect |
|----------|---------|--------|
| Wolf | 100 | +3% Gathering XP |
| Hawk | 100 | +5% Thieving XP |
| Bear | 80 | +5% Strength boost |
| Serpent | 80 | +5% Herblore XP, +5% Farming Yield |
| Phoenix | 60 | +8% Artisan XP |
| Dragon | 60 | +8% Attack & Strength boost |
| Hydra | 50 | +10% Defence boost, +5% Combat XP |
| Titan | 40 | +10% All XP |

Charges decrement per completed skill action or per player attack in combat. When charges reach 0, the familiar auto-dismisses. Combat boosts are added to effective stats alongside potion and prayer boosts.

## Modifier Engine

All passive bonuses flow through a unified modifier engine in `lib/bide-modifiers.hoon`. The `++compute-modifiers` gate collects bonuses from all sources into a single `modifier-set`:

**Sources:**
- Agility milestones (XP bonuses, speed reduction, farming yield, combat XP)
- Astrology constellations (per-skill and global XP bonuses from mastery/level)
- Summoning familiars (XP bonuses, combat stat boosts, farming yield)
- Potions (combat stat boosts)
- Prayers (combat stat boosts, damage reduction)
- Active pet (skill XP, global XP, GP bonus, speed bonus, farming yield)

**`modifier-set` fields:** `xp-global`, `xp-gathering`, `xp-artisan`, `xp-combat`, `xp-per-skill` (map), `speed-bonus`, `atk-boost`, `str-boost`, `def-boost`, `protect-melee`, `protect-ranged`, `protect-magic`, `farming-yield`, `gp-bonus`.

**Helper arms:**
- `++apply-xp-bonus` — applies all relevant XP modifiers for a skill type
- `++apply-speed-bonus` — reduces action base time by speed bonus percentage
- `++get-combat-boosts` — extracts atk/str/def percentages for combat calculations
- `++get-protection` — returns damage reduction percentage for an enemy attack style

Both `process-skill-tick` and `process-combat-events` call `compute-modifiers` once per tick, then use the helper arms.

## Shop

Players can buy items with GP from a shop registry defined in `lib/bide-shop.hoon`. ~43 items available:

| Category | Items | Pricing |
|----------|-------|---------|
| Raw materials | copper-ore, tin-ore, iron-ore, coal, normal-log, oak-log | 2-3x sell price |
| Runes | all 11 rune types | 3x sell price |
| Seeds | all farming seeds | 3-4x sell price |
| Food | cooked-shrimp through cooked-salmon | 2x sell price |
| Misc | vial-of-water, rune-essence, charcoal | fixed low prices |
| Starter gear | bronze-sword, wooden-shield | 50-100 GP |

POST `/buy/<item>/<qty>` deducts GP and adds items to the bank. GP spent is tracked in `total-gp-spent` stat.

## Pets

12 pets obtained as rare drops from skilling and combat. Each pet provides a small passive bonus when set as active.

| Pet | Source | Chance | Effect |
|-----|--------|--------|--------|
| Rocky | Mining | 1/2000 | +2% Mining XP |
| Beaver | Woodcutting | 1/2000 | +2% Woodcutting XP |
| Heron | Fishing | 1/2000 | +2% Fishing XP |
| Ember | Firemaking | 1/2000 | +2% Firemaking XP |
| Nibbles | Thieving | 1/2500 | +3% Thieving XP |
| Golem | Smithing | 1/2500 | +3% Smithing XP |
| Chompy | Cooking | 1/2000 | +2% Cooking XP |
| Sprout | Farming (harvest) | 1/1500 | +5% Farming Yield |
| Rune Sprite | Runecrafting | 1/3000 | +3% Runecrafting XP |
| Phoenix Chick | Fire Giant | 1/3000 | +1% all XP |
| Dragon Whelp | Dragon | 1/5000 | +2% all XP |
| Goblin Runt | Goblin | 1/1000 | +3% GP bonus |

Pet drops are rolled per completed skill action or per monster kill using the PRNG. Only unfound pets are eligible. Found pets are stored in `pets-found` (set). One pet can be active at a time via `active-pet`. Pet bonuses feed into the modifier engine.

Managed on the Equipment page alongside gear and familiars.

## Alt Magic

11 utility spells added as actions to the Magic skill, accessible via `/skill/magic` (linked from the artisan sidebar section). Uses the standard `process-skill-tick` engine with the `gp-per-action` field for alchemy spells.

**Alchemy** (convert items to GP):

| Spell | Level | Runes | Input | GP | XP | Time |
|-------|-------|-------|-------|-----|-----|------|
| Alch Gold Bar | 21 | 5 fire, 1 mind | gold-bar | 225 | 8 | 3s |
| Alch Onyx | 40 | 5 fire, 1 death | onyx | 2,250 | 15 | 3s |
| Alch Dragonite Bar | 55 | 5 fire, 2 death | dragonite-bar | 5,000 | 25 | 3s |

**Superheat** (smelt without furnace):

| Spell | Level | Runes | Input | Output | XP | Time |
|-------|-------|-------|-------|--------|-----|------|
| Superheat Iron | 33 | 4 fire, 1 mind | iron-ore | iron-bar | 10 | 3s |
| Superheat Steel | 43 | 6 fire, 1 chaos | iron-ore | steel-bar | 18 | 4s |
| Superheat Mithril | 53 | 8 fire, 1 death | mithril-ore | mithril-bar | 28 | 5s |
| Superheat Runite | 75 | 12 fire, 2 death | runite-ore | runite-bar | 50 | 6s |

**Enchant** (upgrade bars to enchanted versions):

| Spell | Level | Runes | Input | Output | XP | Time |
|-------|-------|-------|-------|--------|-----|------|
| Enchant Steel | 35 | 5 water, 5 earth | steel-bar | enchanted-steel-bar | 20 | 5s |
| Enchant Mithril | 50 | 5 water, 5 earth, 2 mind | mithril-bar | enchanted-mithril-bar | 30 | 5s |
| Enchant Adamantite | 65 | 5 water, 5 earth, 3 chaos | adamantite-bar | enchanted-adamantite-bar | 45 | 6s |
| Enchant Runite | 80 | 10 water, 10 earth, 5 death | runite-bar | enchanted-runite-bar | 65 | 6s |

Enchanted bars are new items (`category=%processed`) with 3x the sell price of normal bars.

## Combat Spells

12 combat spells defined in `lib/bide-spells.hoon` allow magic-based combat without requiring a magic weapon. When magic style is selected on the combat page, the player chooses a spell. Each attack consumes runes from the bank; combat auto-stops when runes are insufficient.

Spell-based attacks use a fixed 3000ms attack speed. Damage is rolled 0 to the spell's fixed max hit. Accuracy is computed from the player's magic level and magic attack bonus (from equipment, if any) vs the enemy's defence.

**Strike Spells** (beginner):

| Spell | Level | Max Hit | Runes |
|-------|-------|---------|-------|
| Wind Strike | 1 | 2 | 2 air, 1 mind |
| Water Strike | 5 | 4 | 2 water, 2 air, 1 mind |
| Earth Strike | 9 | 6 | 2 earth, 2 air, 1 mind |
| Fire Strike | 13 | 8 | 3 fire, 2 air, 1 mind |

**Bolt Spells** (intermediate):

| Spell | Level | Max Hit | Runes |
|-------|-------|---------|-------|
| Air Bolt | 17 | 10 | 3 air, 1 chaos |
| Water Bolt | 23 | 13 | 3 water, 2 air, 1 chaos |
| Earth Bolt | 29 | 16 | 3 earth, 2 air, 1 chaos |
| Fire Bolt | 35 | 19 | 4 fire, 3 air, 1 chaos |

**Blast Spells** (advanced):

| Spell | Level | Max Hit | Runes |
|-------|-------|---------|-------|
| Air Blast | 41 | 22 | 4 air, 1 death |
| Fire Blast | 59 | 28 | 5 fire, 4 air, 1 death |

**Surge Spells** (expert):

| Spell | Level | Max Hit | Runes |
|-------|-------|---------|-------|
| Air Surge | 75 | 36 | 7 air, 1 blood |
| Fire Surge | 90 | 46 | 10 fire, 7 air, 1 blood |

## Completion Log

Tracks overall game progress across 5 categories, each contributing equally to the overall completion percentage:

1. **Skills** — count at level 99 / total skills
2. **Mastery** — total mastery levels / max mastery levels (per-skill breakdown with pool XP)
3. **Monsters** — unique monsters killed / total monsters
4. **Dungeons** — unique dungeons cleared / total dungeons
5. **Pets** — pets found / total pets

**Statistics tracked** in `game-stats`:
- `actions-completed` — per-action count
- `monsters-killed` — per-monster count
- `items-produced` — per-item count
- `dungeons-completed` — per-dungeon count
- `total-xp-earned` — cumulative XP
- `total-gp-earned` — cumulative GP (from sells, combat drops, thieving, alchemy)
- `total-gp-spent` — cumulative GP (from shop purchases)
- `max-hit-dealt` — highest single hit
