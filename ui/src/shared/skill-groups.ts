import type { ActionId, SkillId } from './types';

export interface SkillGroup {
  label: string;
  actionIds: ActionId[];
}

export const SKILL_GROUPS: Partial<Record<SkillId, SkillGroup[]>> = {
  smithing: [
    { label: 'Bars', actionIds: ['smelt-bronze-bar', 'smelt-iron-bar', 'smelt-silver-bar', 'smelt-gold-bar', 'smelt-steel-bar', 'smelt-mithril-bar', 'smelt-adamantite-bar', 'smelt-runite-bar', 'smelt-dragonite-bar'] },
    { label: 'Bronze', actionIds: ['forge-bronze-dagger', 'forge-bronze-sword', 'forge-bronze-battleaxe', 'forge-bronze-2h-sword', 'forge-bronze-shield'] },
    { label: 'Iron', actionIds: ['forge-iron-dagger', 'forge-iron-sword', 'forge-iron-battleaxe', 'forge-iron-2h-sword', 'forge-iron-shield'] },
    { label: 'Steel', actionIds: ['forge-steel-dagger', 'forge-steel-sword', 'forge-steel-battleaxe', 'forge-steel-2h-sword', 'forge-steel-shield'] },
    { label: 'Mithril', actionIds: ['forge-mithril-dagger', 'forge-mithril-sword', 'forge-mithril-battleaxe', 'forge-mithril-2h-sword', 'forge-mithril-shield'] },
    { label: 'Adamantite', actionIds: ['forge-adamantite-dagger', 'forge-adamantite-sword', 'forge-adamantite-battleaxe', 'forge-adamantite-2h-sword', 'forge-adamantite-shield'] },
    { label: 'Runite', actionIds: ['forge-runite-dagger', 'forge-runite-sword', 'forge-runite-battleaxe', 'forge-runite-2h-sword', 'forge-runite-shield'] },
    { label: 'Dragonite', actionIds: ['forge-dragonite-dagger', 'forge-dragonite-sword', 'forge-dragonite-battleaxe', 'forge-dragonite-2h-sword', 'forge-dragonite-shield'] },
  ],
  fletching: [
    { label: 'Normal', actionIds: ['fletch-normal-shortbow', 'fletch-normal-longbow', 'fletch-normal-crossbow'] },
    { label: 'Oak', actionIds: ['fletch-oak-shortbow', 'fletch-oak-longbow', 'fletch-oak-crossbow'] },
    { label: 'Willow', actionIds: ['fletch-willow-shortbow', 'fletch-willow-longbow', 'fletch-willow-crossbow'] },
    { label: 'Maple', actionIds: ['fletch-maple-shortbow', 'fletch-maple-longbow', 'fletch-maple-crossbow'] },
    { label: 'Yew', actionIds: ['fletch-yew-shortbow', 'fletch-yew-longbow', 'fletch-yew-crossbow'] },
    { label: 'Magic', actionIds: ['fletch-magic-shortbow', 'fletch-magic-longbow', 'fletch-magic-crossbow'] },
    { label: 'Redwood', actionIds: ['fletch-redwood-shortbow', 'fletch-redwood-longbow', 'fletch-redwood-crossbow'] },
    { label: 'Arrows', actionIds: ['fletch-bronze-arrows', 'fletch-iron-arrows', 'fletch-steel-arrows', 'fletch-mithril-arrows', 'fletch-adamantite-arrows', 'fletch-runite-arrows', 'fletch-dragonite-arrows'] },
  ],
  crafting: [
    { label: 'Bronze', actionIds: ['craft-bronze-helmet', 'craft-bronze-platebody'] },
    { label: 'Iron', actionIds: ['craft-iron-helmet', 'craft-iron-platebody'] },
    { label: 'Steel', actionIds: ['craft-steel-helmet', 'craft-steel-platebody'] },
    { label: 'Mithril', actionIds: ['craft-mithril-helmet', 'craft-mithril-platebody'] },
    { label: 'Adamantite', actionIds: ['craft-adamantite-helmet', 'craft-adamantite-platebody'] },
    { label: 'Runite', actionIds: ['craft-runite-helmet', 'craft-runite-platebody'] },
    { label: 'Dragonite', actionIds: ['craft-dragonite-helmet', 'craft-dragonite-platebody'] },
    { label: 'Leather', actionIds: ['craft-leather-cowl', 'craft-leather-body'] },
    { label: 'Green Dhide', actionIds: ['craft-green-dhide-coif', 'craft-green-dhide-body'] },
    { label: 'Blue Dhide', actionIds: ['craft-blue-dhide-coif', 'craft-blue-dhide-body'] },
    { label: 'Red Dhide', actionIds: ['craft-red-dhide-coif', 'craft-red-dhide-body'] },
    { label: 'Black Dhide', actionIds: ['craft-black-dhide-coif', 'craft-black-dhide-body'] },
    { label: 'Jewelry', actionIds: ['craft-topaz-ring', 'craft-topaz-necklace', 'craft-sapphire-ring', 'craft-sapphire-necklace', 'craft-ruby-ring', 'craft-ruby-necklace', 'craft-emerald-ring', 'craft-emerald-necklace', 'craft-diamond-ring', 'craft-diamond-necklace'] },
  ],
  herblore: [
    { label: 'Combat Potions', actionIds: ['brew-attack-potion', 'brew-strength-potion', 'brew-defence-potion', 'brew-hitpoints-potion', 'brew-prayer-potion', 'brew-ranged-potion', 'brew-magic-potion'] },
    { label: 'Super Potions', actionIds: ['brew-super-attack-potion', 'brew-super-strength-potion', 'brew-super-defence-potion', 'brew-super-ranged-potion', 'brew-super-magic-potion'] },
  ],
  magic: [
    { label: 'Alchemy', actionIds: ['alch-gold-bar', 'alch-onyx', 'alch-dragonite-bar'] },
    { label: 'Superheat', actionIds: ['superheat-iron', 'superheat-steel', 'superheat-mithril', 'superheat-runite'] },
    { label: 'Enchant', actionIds: ['enchant-steel', 'enchant-mithril', 'enchant-adamantite', 'enchant-runite'] },
  ],
};
