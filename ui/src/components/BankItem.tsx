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
  const borderColor = category ? CATEGORY_COLORS[category] : '#374151';
  const isFood = !!defs?.foodHealing[itemId];
  const potionDef = defs?.potions[itemId];
  const isInstantPotion = potionDef && potionDef.duration === 0;
  const isCombatPotion = potionDef && potionDef.duration > 0;

  return (
    <div
      className="relative bg-[#111827] border border-[#374151] rounded-md p-4 text-center transition-all duration-200 hover:border-gray-500 hover:shadow-[0_0_8px_rgba(255,255,255,0.03)]"
      style={{ borderTopColor: borderColor, borderTopWidth: '2px' }}
      title={idef ? `${name}\nCategory: ${idef.category}\nSell: ${fmt(price)} GP each\nTotal: ${fmt(price * qty)} GP` : name}
    >
      <div className="absolute top-1.5 right-1.5 min-w-[22px] h-[18px] px-1.5 text-[11px] font-bold leading-[18px] text-center bg-[#374151] text-gray-100 rounded-[9px]">
        {fmt(qty)}
      </div>
      <div className="w-14 h-14 mx-auto mb-3 bg-[#1f2937] rounded-md flex items-center justify-center text-[22px] text-gray-500">
        &#x1f4e6;
      </div>
      <div className="text-[13px] font-medium text-gray-400 whitespace-nowrap overflow-hidden text-ellipsis">
        {name}
      </div>
      {price > 0 && (
        <div className="text-xs text-gray-500 mt-0.5">{fmt(price)} GP</div>
      )}
      <div className="mt-3 flex flex-col gap-1.5">
        {isFood && (
          <button
            onClick={() => eatFood(itemId)}
            className="w-full px-2 py-1 rounded text-xs font-medium bg-green-700 hover:bg-green-600 text-gray-100 cursor-pointer transition-colors"
            title={`Heals ${defs?.foodHealing[itemId]} HP`}
          >
            Eat
          </button>
        )}
        {isInstantPotion && (
          <button
            onClick={() => drinkPotion(itemId)}
            className="w-full px-2 py-1 rounded text-xs font-medium bg-teal-700 hover:bg-teal-600 text-gray-100 cursor-pointer transition-colors"
          >
            Drink
          </button>
        )}
        {isCombatPotion && (
          <button
            disabled
            className="w-full px-2 py-1 rounded text-xs font-medium bg-gray-700 text-gray-500 cursor-not-allowed"
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
