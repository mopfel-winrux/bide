import { useState, useMemo } from 'react';
import { useGame } from '../context/GameContext';
import { GameIcon } from '../components/ui/GameIcon';
import { fmt } from '../shared/format';
import type { ItemCategory, ItemId, SkillId } from '../shared/types';

const SHOP_CATEGORIES: ItemCategory[] = [
  'raw-material', 'rune', 'seed', 'food', 'misc', 'equipment',
];

const CATEGORY_DISPLAY: Record<string, string> = {
  'raw-material': 'Raw Materials',
  rune: 'Runes',
  seed: 'Seeds',
  food: 'Food',
  misc: 'Miscellaneous',
  equipment: 'Equipment',
};

const QTY_OPTIONS = [1, 5, 10] as const;

type ShopTab = 'items' | 'upgrades';

const GATHERING_SKILLS: SkillId[] = ['woodcutting', 'fishing', 'mining', 'thieving', 'firemaking'];
const ARTISAN_SKILLS: SkillId[] = ['cooking', 'smithing', 'fletching', 'crafting', 'runecrafting', 'herblore'];

const UPGRADE_TIERS = [
  { tier: 1, xpBonus: 3, speedBonus: 3, preservationBonus: 3, xpPrice: 100_000, speedPrice: 150_000, preservationPrice: 150_000 },
  { tier: 2, xpBonus: 5, speedBonus: 5, preservationBonus: 5, xpPrice: 500_000, speedPrice: 750_000, preservationPrice: 750_000 },
  { tier: 3, xpBonus: 8, speedBonus: 8, preservationBonus: 8, xpPrice: 2_000_000, speedPrice: 3_000_000, preservationPrice: 3_000_000 },
];

const MULTITREE_PRICE = 1_000_000;

export function ShopPage() {
  const { state, defs, buyItem, buySkillUpgrade, buyMultitree } = useGame();
  const [selectedQty, setSelectedQty] = useState<number | 'all'>(1);
  const [activeItemTab, setActiveItemTab] = useState<ItemCategory | null>(null);
  const [shopTab, setShopTab] = useState<ShopTab>('items');

  const grouped = useMemo(() => {
    if (!defs) return new Map<ItemCategory, { id: ItemId; name: string; price: number }[]>();

    const groups = new Map<ItemCategory, { id: ItemId; name: string; price: number }[]>();

    for (const [itemId, price] of Object.entries(defs.shop)) {
      const itemDef = defs.items[itemId];
      if (!itemDef) continue;
      const cat = itemDef.category;
      if (!groups.has(cat)) groups.set(cat, []);
      groups.get(cat)!.push({ id: itemId, name: itemDef.name, price });
    }

    for (const items of groups.values()) {
      items.sort((a, b) => a.name.localeCompare(b.name));
    }

    return groups;
  }, [defs]);

  if (!state || !defs) return null;

  const gp = state.gp;

  function getQty(price: number): number {
    if (selectedQty === 'all') {
      return Math.max(1, Math.floor(gp / price));
    }
    return selectedQty;
  }

  function getTier(skill: SkillId, type: string): number {
    return state?.skillUpgrades?.[`${skill}-${type}`] ?? 0;
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold text-gray-100">Shop</h2>
        <div className="text-yellow-500 font-semibold text-sm">
          {fmt(gp)} GP
        </div>
      </div>

      {/* Main tabs: Items / Upgrades */}
      <div className="flex gap-2 mb-6">
        {(['items', 'upgrades'] as ShopTab[]).map((tab) => (
          <button
            key={tab}
            onClick={() => setShopTab(tab)}
            className={`px-4 py-2 text-sm rounded-md border font-medium transition-all duration-150 cursor-pointer ${
              shopTab === tab
                ? 'border-amber-600 bg-amber-600/10 text-amber-500'
                : 'border-[#1e293b] bg-transparent text-gray-500 hover:text-gray-300'
            }`}
          >
            {tab === 'items' ? 'Buy Items' : 'Upgrades'}
          </button>
        ))}
      </div>

      {shopTab === 'items' && (
        <>
          {/* Quantity selector */}
          <div className="flex items-center gap-2 mb-6">
            <span className="text-xs text-gray-500">Buy quantity:</span>
            {QTY_OPTIONS.map((q) => (
              <button
                key={q}
                onClick={() => setSelectedQty(q)}
                className={`px-3 py-1.5 text-xs rounded-md border transition-all duration-150 cursor-pointer ${
                  selectedQty === q
                    ? 'border-amber-600 bg-amber-600/10 text-amber-500'
                    : 'border-[#1e293b] bg-transparent text-gray-500 hover:text-gray-300'
                }`}
              >
                {q}
              </button>
            ))}
            <button
              onClick={() => setSelectedQty('all')}
              className={`px-3 py-1.5 text-xs rounded-md border transition-all duration-150 cursor-pointer ${
                selectedQty === 'all'
                  ? 'border-amber-600 bg-amber-600/10 text-amber-500'
                  : 'border-[#1e293b] bg-transparent text-gray-500 hover:text-gray-300'
              }`}
            >
              All
            </button>
          </div>

          {/* Item category tabs */}
          {(() => {
            const availableCats = SHOP_CATEGORIES.filter(cat => {
              const items = grouped.get(cat);
              return items && items.length > 0;
            });
            const currentTab = activeItemTab && availableCats.includes(activeItemTab) ? activeItemTab : availableCats[0] ?? null;
            const currentItems = currentTab ? grouped.get(currentTab) ?? [] : [];

            return (
              <div>
                <div className="flex flex-wrap gap-1 mb-5">
                  {availableCats.map((cat) => (
                    <button
                      key={cat}
                      onClick={() => setActiveItemTab(cat)}
                      className={`px-3 py-1.5 text-xs rounded-md border transition-all duration-150 cursor-pointer ${
                        currentTab === cat
                          ? 'border-amber-600 bg-amber-600/10 text-amber-500'
                          : 'border-[#1e293b] bg-transparent text-gray-500 hover:text-gray-300'
                      }`}
                    >
                      {CATEGORY_DISPLAY[cat] ?? cat}
                    </button>
                  ))}
                </div>
                <div className="space-y-2">
                  {currentItems.map(({ id, name, price }) => {
                    const owned = state.bank[id] ?? 0;
                    const qty = getQty(price);
                    const totalCost = price * qty;
                    const canAfford = gp >= price;

                    return (
                      <div
                        key={id}
                        className="flex items-center justify-between bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-2"
                      >
                        <GameIcon category="items" id={id} size={32} className="mr-3 shrink-0" />
                        <div className="flex-1 min-w-0">
                          <div className="text-sm text-gray-200">{name}</div>
                          <div className="text-xs text-gray-500">
                            {fmt(price)} GP each
                            {owned > 0 && (
                              <span className="ml-2 text-gray-400">
                                Owned: {fmt(owned)}
                              </span>
                            )}
                            {defs.capes?.[id] && (() => {
                              const cape = defs.capes[id];
                              const skillLevel = state.skills[cape.skill]?.level ?? 1;
                              const has99 = skillLevel >= 99;
                              return (
                                <span className={`ml-2 ${has99 ? 'text-green-400' : 'text-red-400'}`}>
                                  Requires Lvl 99 {cape.skill} ({skillLevel}/99)
                                </span>
                              );
                            })()}
                          </div>
                        </div>
                        <div className="flex items-center gap-3 ml-4">
                          <span className="text-xs text-gray-400 whitespace-nowrap">
                            {fmt(totalCost)} GP
                          </span>
                          <button
                            onClick={() => buyItem(id, qty)}
                            disabled={!canAfford}
                            className={`px-3 py-1 rounded text-xs font-medium transition-colors whitespace-nowrap ${
                              canAfford
                                ? 'bg-amber-600 hover:bg-amber-500 text-gray-100 cursor-pointer'
                                : 'bg-gray-700 text-gray-500 cursor-not-allowed'
                            }`}
                          >
                            Buy {selectedQty === 'all' ? fmt(qty) : qty}
                          </button>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            );
          })()}
        </>
      )}

      {shopTab === 'upgrades' && (
        <div className="space-y-6">
          {/* Multitree unlock */}
          <div>
            <h3 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Unlocks</h3>
            <div className="bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-3 flex items-center justify-between">
              <div>
                <div className="text-sm text-gray-200 font-medium">Multi-Tree (Woodcutting)</div>
                <div className="text-xs text-gray-500">Cut two trees at once. Time = slowest tree, get both logs + XP.</div>
              </div>
              {state.multitreeUnlocked ? (
                <span className="text-xs font-medium text-green-400 px-3 py-1">Purchased</span>
              ) : (
                <button
                  onClick={buyMultitree}
                  disabled={gp < MULTITREE_PRICE}
                  className={`px-3 py-1.5 rounded text-xs font-medium transition-colors whitespace-nowrap ${
                    gp >= MULTITREE_PRICE
                      ? 'bg-amber-600 hover:bg-amber-500 text-gray-100 cursor-pointer'
                      : 'bg-gray-700 text-gray-500 cursor-not-allowed'
                  }`}
                >
                  Buy ({fmt(MULTITREE_PRICE)} GP)
                </button>
              )}
            </div>
          </div>

          {/* Gathering skill upgrades */}
          <div>
            <h3 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Gathering Skills</h3>
            <div className="space-y-2">
              {GATHERING_SKILLS.map((sid) => {
                const skillName = defs.skills[sid]?.name ?? sid;
                const xpTier = getTier(sid, 'xp');
                const speedTier = getTier(sid, 'speed');
                const nextXp = UPGRADE_TIERS[xpTier];
                const nextSpeed = UPGRADE_TIERS[speedTier];
                return (
                  <div key={sid} className="bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-3">
                    <div className="flex items-center gap-2 mb-2">
                      <GameIcon category="skill-icon" id={sid} size={24} />
                      <span className="text-sm text-gray-200 font-medium">{skillName}</span>
                    </div>
                    <div className="flex gap-2">
                      <UpgradeButton
                        label={`XP +${xpTier > 0 ? UPGRADE_TIERS[xpTier - 1].xpBonus : 0}%`}
                        nextLabel={nextXp ? `+${nextXp.xpBonus}%` : 'MAX'}
                        price={nextXp?.xpPrice ?? 0}
                        tier={xpTier}
                        canAfford={!!nextXp && gp >= nextXp.xpPrice}
                        maxed={!nextXp}
                        onClick={() => buySkillUpgrade(sid, 'xp')}
                      />
                      <UpgradeButton
                        label={`Speed +${speedTier > 0 ? UPGRADE_TIERS[speedTier - 1].speedBonus : 0}%`}
                        nextLabel={nextSpeed ? `+${nextSpeed.speedBonus}%` : 'MAX'}
                        price={nextSpeed?.speedPrice ?? 0}
                        tier={speedTier}
                        canAfford={!!nextSpeed && gp >= nextSpeed.speedPrice}
                        maxed={!nextSpeed}
                        onClick={() => buySkillUpgrade(sid, 'speed')}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Artisan skill upgrades */}
          <div>
            <h3 className="text-sm font-semibold uppercase tracking-wider text-gray-500 mb-3">Artisan Skills</h3>
            <div className="space-y-2">
              {ARTISAN_SKILLS.map((sid) => {
                const skillName = defs.skills[sid]?.name ?? sid;
                const xpTier = getTier(sid, 'xp');
                const preservationTier = getTier(sid, 'preservation');
                const nextXp = UPGRADE_TIERS[xpTier];
                const nextPres = UPGRADE_TIERS[preservationTier];
                return (
                  <div key={sid} className="bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-3">
                    <div className="flex items-center gap-2 mb-2">
                      <GameIcon category="skill-icon" id={sid} size={24} />
                      <span className="text-sm text-gray-200 font-medium">{skillName}</span>
                    </div>
                    <div className="flex gap-2">
                      <UpgradeButton
                        label={`XP +${xpTier > 0 ? UPGRADE_TIERS[xpTier - 1].xpBonus : 0}%`}
                        nextLabel={nextXp ? `+${nextXp.xpBonus}%` : 'MAX'}
                        price={nextXp?.xpPrice ?? 0}
                        tier={xpTier}
                        canAfford={!!nextXp && gp >= nextXp.xpPrice}
                        maxed={!nextXp}
                        onClick={() => buySkillUpgrade(sid, 'xp')}
                      />
                      <UpgradeButton
                        label={`Preserve ${preservationTier > 0 ? UPGRADE_TIERS[preservationTier - 1].preservationBonus : 0}%`}
                        nextLabel={nextPres ? `${nextPres.preservationBonus}%` : 'MAX'}
                        price={nextPres?.preservationPrice ?? 0}
                        tier={preservationTier}
                        canAfford={!!nextPres && gp >= nextPres.preservationPrice}
                        maxed={!nextPres}
                        onClick={() => buySkillUpgrade(sid, 'preservation')}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function UpgradeButton({ label, nextLabel, price, tier, canAfford, maxed, onClick }: {
  label: string; nextLabel: string; price: number; tier: number; canAfford: boolean; maxed: boolean; onClick: () => void;
}) {
  return (
    <button
      onClick={onClick}
      disabled={maxed || !canAfford}
      className={`flex-1 rounded-lg border p-2.5 text-left transition-colors ${
        maxed
          ? 'border-amber-700/30 bg-amber-900/10 cursor-default'
          : canAfford
            ? 'border-blue-700/50 bg-blue-900/10 hover:bg-blue-800/20 cursor-pointer'
            : 'border-gray-700/30 bg-gray-900/10 cursor-not-allowed'
      }`}
    >
      <div className={`text-xs font-medium ${maxed ? 'text-amber-400' : 'text-gray-300'}`}>
        {label}
      </div>
      <div className="flex items-center justify-between mt-1">
        <span className={`text-[11px] ${maxed ? 'text-amber-500' : 'text-blue-400'}`}>
          {maxed ? 'Maxed' : `Next: ${nextLabel}`}
        </span>
        {!maxed && (
          <span className={`text-[11px] ${canAfford ? 'text-green-400' : 'text-red-400'}`}>
            {fmt(price)} GP
          </span>
        )}
      </div>
      <div className="flex gap-0.5 mt-1.5">
        {[1, 2, 3].map((t) => (
          <div
            key={t}
            className={`h-1 flex-1 rounded-full ${
              t <= tier ? 'bg-amber-500' : 'bg-gray-700'
            }`}
          />
        ))}
      </div>
    </button>
  );
}
