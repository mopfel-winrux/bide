import { useGame } from '../context/GameContext';
import { Button } from './ui/Button';
import { fmt } from '../shared/format';
import { CATEGORY_COLORS } from '../shared/constants';
import type { ItemId, ItemCategory } from '../shared/types';

interface Props {
  itemId: ItemId;
  qty: number;
}

export function BankItem({ itemId, qty }: Props) {
  const { defs, sellAll, eatFood, drinkPotion } = useGame();
  const idef = defs?.items[itemId];
  const name = idef?.name ?? itemId;
  const price = idef?.sellPrice ?? 0;
  const category = idef?.category as ItemCategory | undefined;
  const borderColor = category ? CATEGORY_COLORS[category] : '#1e293b';
  const isFood = !!defs?.foodHealing[itemId];
  const potionDef = defs?.potions[itemId];
  const isInstantPotion = potionDef && potionDef.duration === 0;
  const isCombatPotion = potionDef && potionDef.duration > 0;

  return (
    <div
      className="relative bg-[#111827] border border-[#1e293b] rounded-lg p-3 text-center transition-all duration-200 hover:border-[#374151] hover:bg-[#131b2e]"
      style={{ borderTopColor: borderColor, borderTopWidth: '2px' }}
      title={idef ? `${name}\nCategory: ${idef.category}\nSell: ${fmt(price)} GP each\nTotal: ${fmt(price * qty)} GP` : name}
    >
      <div className="absolute top-1.5 right-1.5 min-w-[22px] h-[18px] px-1.5 text-[10px] font-bold leading-[18px] text-center bg-[#1e293b] text-gray-300 rounded-md tabular-nums">
        {fmt(qty)}
      </div>
      <div className="w-12 h-12 mx-auto mb-2 bg-[#0d1117] rounded-md flex items-center justify-center text-[20px] text-gray-600">
        &#x1f4e6;
      </div>
      <div className="text-[12px] font-medium text-gray-300 whitespace-nowrap overflow-hidden text-ellipsis">
        {name}
      </div>
      {price > 0 && (
        <div className="text-[11px] text-gray-600 mt-0.5 tabular-nums">{fmt(price)} GP</div>
      )}
      <div className="mt-2.5 flex flex-col gap-1.5">
        {isFood && (
          <button
            onClick={() => eatFood(itemId)}
            className="w-full px-2 py-1 rounded text-[11px] font-medium bg-emerald-800/50 hover:bg-emerald-700/50 text-emerald-300 cursor-pointer transition-colors"
            title={`Heals ${defs?.foodHealing[itemId]} HP`}
          >
            Eat
          </button>
        )}
        {isInstantPotion && (
          <button
            onClick={() => drinkPotion(itemId)}
            className="w-full px-2 py-1 rounded text-[11px] font-medium bg-teal-800/50 hover:bg-teal-700/50 text-teal-300 cursor-pointer transition-colors"
          >
            Drink
          </button>
        )}
        {isCombatPotion && (
          <button
            disabled
            className="w-full px-2 py-1 rounded text-[11px] font-medium bg-[#1e293b] text-gray-600 cursor-not-allowed"
            title="Use during combat"
          >
            Combat Only
          </button>
        )}
        <Button size="sm" onClick={() => sellAll(itemId)} title={`Sell for ${fmt(price * qty)} GP`}>
          Sell All
        </Button>
      </div>
    </div>
  );
}
