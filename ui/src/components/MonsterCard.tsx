import type { MonsterId, MonsterDef, GameDefs } from '../shared/types';
import { GameIcon } from './ui/GameIcon';
import { fmt } from '../shared/format';

interface MonsterCardProps {
  monsterId: MonsterId;
  monster: MonsterDef;
  selected: boolean;
  onSelect: () => void;
  defs: GameDefs;
}

export function MonsterCard({ monsterId, monster, selected, onSelect, defs }: MonsterCardProps) {
  return (
    <button
      onClick={onSelect}
      className={`text-left w-full p-4 rounded-lg border transition-colors cursor-pointer ${
        selected
          ? 'bg-[#1a2332] border-amber-600 ring-1 ring-amber-600/30'
          : 'bg-[#111827] border-[#1e293b] hover:border-gray-500'
      }`}
    >
      <div className="flex items-center gap-3 mb-2">
        <GameIcon category="monster" id={monsterId} size={48} fallback={monster.name.charAt(0)} />
        <div className="font-medium text-gray-200">{monster.name}</div>
      </div>
      <div className="grid grid-cols-2 gap-x-4 gap-y-1 text-xs text-gray-500">
        <div>HP: <span className="text-gray-400">{fmt(monster.hitpoints)}</span></div>
        <div>Max Hit: <span className="text-gray-400">{fmt(monster.maxHit)}</span></div>
        <div>Atk: <span className="text-gray-400">{monster.attackLevel}</span></div>
        <div>Str: <span className="text-gray-400">{monster.strengthLevel}</span></div>
        <div>Def: <span className="text-gray-400">{monster.defenceLevel}</span></div>
        <div>Speed: <span className="text-gray-400">{(monster.attackSpeed / 1000).toFixed(1)}s</span></div>
        <div>XP: <span className="text-gray-400">{fmt(monster.combatXp)}</span></div>
        <div>GP: <span className="text-gray-400">{fmt(monster.gpMin)}-{fmt(monster.gpMax)}</span></div>
        {monster.slayerReq > 0 && (
          <div className="col-span-2">Slayer: <span className="text-orange-400">{monster.slayerReq}</span></div>
        )}
      </div>
      {monster.lootTable.length > 0 && (
        <div className="mt-2 text-xs text-gray-500">
          Drops: {monster.lootTable.map((l) => defs.items[l.item]?.name ?? l.item).join(', ')}
        </div>
      )}
    </button>
  );
}
