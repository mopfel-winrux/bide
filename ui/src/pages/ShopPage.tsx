import { useState, useMemo } from 'react';
import { useGame } from '../context/GameContext';
import { GameIcon } from '../components/ui/GameIcon';
import { fmt } from '../shared/format';
import type { ItemCategory, ItemId } from '../shared/types';

const SHOP_CATEGORIES: ItemCategory[] = [
  'raw-material', 'rune', 'seed', 'food', 'misc', 'equipment',
];

const CATEGORY_DISPLAY: Record<string, string> = {
  'raw-material': 'Raw Materials',
  rune: 'Runes',
  seed: 'Seeds',
  food: 'Food',
  misc: 'Miscellaneous',
  equipment: 'Skill Capes',
};

const QTY_OPTIONS = [1, 5, 10] as const;

export function ShopPage() {
  const { state, defs, buyItem } = useGame();
  const [selectedQty, setSelectedQty] = useState<number | 'all'>(1);
  const [activeTab, setActiveTab] = useState<ItemCategory | null>(null);

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

    // Sort items within each category by name
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

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold text-gray-100">Shop</h2>
        <div className="text-yellow-500 font-semibold text-sm">
          {fmt(gp)} GP
        </div>
      </div>

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

      {/* Shop category tabs */}
      {(() => {
        const availableCats = SHOP_CATEGORIES.filter(cat => {
          const items = grouped.get(cat);
          return items && items.length > 0;
        });
        const currentTab = activeTab && availableCats.includes(activeTab) ? activeTab : availableCats[0] ?? null;
        const currentItems = currentTab ? grouped.get(currentTab) ?? [] : [];

        return (
          <div>
            <div className="flex flex-wrap gap-1 mb-5">
              {availableCats.map((cat) => (
                <button
                  key={cat}
                  onClick={() => setActiveTab(cat)}
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
    </div>
  );
}
