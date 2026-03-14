import { useState, useMemo } from 'react';
import { useGame } from '../context/GameContext';
import { BankItem } from '../components/BankItem';
import { EmptyState } from '../components/ui/EmptyState';
import { fmt } from '../shared/format';
import { CATEGORY_LABELS } from '../shared/constants';
import type { ItemCategory } from '../shared/types';

type SortMode = 'name' | 'qty' | 'value';

const ALL_CATEGORIES: (ItemCategory | 'all')[] = [
  'all', 'raw-material', 'processed', 'equipment', 'food', 'gem', 'rune', 'potion', 'seed', 'tablet', 'misc',
];

export function BankPage() {
  const { state, defs, getDisplayBank } = useGame();
  const [category, setCategory] = useState<ItemCategory | 'all'>('all');
  const [sort, setSort] = useState<SortMode>('name');

  const bank = getDisplayBank();
  const itemCount = Object.keys(bank).length;

  const sortedItems = useMemo(() => {
    let entries = Object.entries(bank);

    if (category !== 'all') {
      entries = entries.filter(([iid]) => defs?.items[iid]?.category === category);
    }

    entries.sort(([aId, aQty], [bId, bQty]) => {
      const aDef = defs?.items[aId];
      const bDef = defs?.items[bId];
      switch (sort) {
        case 'name':
          return (aDef?.name ?? aId).localeCompare(bDef?.name ?? bId);
        case 'qty':
          return bQty - aQty;
        case 'value':
          return ((bDef?.sellPrice ?? 0) * bQty) - ((aDef?.sellPrice ?? 0) * aQty);
        default:
          return 0;
      }
    });

    return entries;
  }, [bank, category, sort, defs]);

  if (!state) return null;

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold">Bank</h2>
        <div className="text-[13px] text-gray-400">
          <span className="text-yellow-500 font-semibold">{fmt(state.gp)} GP</span>
          {' | '}
          {itemCount} items
        </div>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-2 mb-5">
        {ALL_CATEGORIES.map((cat) => (
          <button
            key={cat}
            onClick={() => setCategory(cat)}
            className={`px-3 py-1.5 text-xs rounded-md border transition-all duration-150 cursor-pointer ${
              category === cat
                ? 'border-amber-600 bg-amber-600/10 text-amber-500'
                : 'border-[#1e293b] bg-transparent text-gray-500 hover:text-gray-300'
            }`}
          >
            {cat === 'all' ? 'All' : CATEGORY_LABELS[cat]}
          </button>
        ))}
      </div>

      {/* Sort */}
      <div className="flex gap-2 mb-5">
        <span className="text-[11px] text-gray-500 self-center mr-1">Sort:</span>
        {(['name', 'qty', 'value'] as SortMode[]).map((s) => (
          <button
            key={s}
            onClick={() => setSort(s)}
            className={`px-2 py-0.5 text-[11px] rounded border transition-all duration-150 cursor-pointer ${
              sort === s
                ? 'border-gray-500 text-gray-100'
                : 'border-transparent text-gray-500 hover:text-gray-300'
            }`}
          >
            {s.charAt(0).toUpperCase() + s.slice(1)}
          </button>
        ))}
      </div>

      {itemCount === 0 ? (
        <EmptyState>Your bank is empty. Start training a skill to earn items!</EmptyState>
      ) : sortedItems.length === 0 ? (
        <EmptyState>No items match this filter.</EmptyState>
      ) : (
        <div className="grid grid-cols-[repeat(auto-fill,minmax(140px,1fr))] gap-3">
          {sortedItems.map(([iid, qty]) => (
            <BankItem key={iid} itemId={iid} qty={qty} />
          ))}
        </div>
      )}
    </div>
  );
}
