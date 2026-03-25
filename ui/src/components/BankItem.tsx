import { useGame } from '../context/GameContext';
import { GameIcon } from './ui/GameIcon';
import { fmt } from '../shared/format';
import { CATEGORY_COLORS } from '../shared/constants';
import type { ItemId, ItemCategory } from '../shared/types';

interface Props {
  itemId: ItemId;
  qty: number;
  selected?: boolean;
  onClick?: () => void;
}

export function BankItem({ itemId, qty, selected, onClick }: Props) {
  const { defs } = useGame();
  const idef = defs?.items[itemId];
  const name = idef?.name ?? itemId;
  const price = idef?.sellPrice ?? 0;
  const category = idef?.category as ItemCategory | undefined;
  const borderColor = category ? CATEGORY_COLORS[category] : '#1e293b';

  return (
    <div
      onClick={onClick}
      className={`relative bg-[#111827] border rounded-lg p-3 text-center transition-all duration-200 cursor-pointer ${
        selected
          ? 'border-amber-500/70 bg-[#1a1f2e] ring-1 ring-amber-500/30'
          : 'border-[#1e293b] hover:border-[#374151] hover:bg-[#131b2e]'
      }`}
      style={{ borderTopColor: selected ? undefined : borderColor, borderTopWidth: selected ? undefined : '2px' }}
      title={idef ? `${name}\nCategory: ${idef.category}\nSell: ${fmt(price)} GP each\nTotal: ${fmt(price * qty)} GP` : name}
    >
      <div className="absolute top-1.5 right-1.5 min-w-[22px] h-[18px] px-1.5 text-[10px] font-bold leading-[18px] text-center bg-[#1e293b] text-gray-300 rounded-md tabular-nums">
        {fmt(qty)}
      </div>
      <GameIcon category="items" id={itemId} size={56} className="mx-auto mb-2" />
      <div className="text-[13px] font-medium text-gray-300 whitespace-nowrap overflow-hidden text-ellipsis">
        {name}
      </div>
      {price > 0 && (
        <div className="text-[11px] text-gray-600 mt-0.5 tabular-nums">{fmt(price)} GP</div>
      )}
    </div>
  );
}
