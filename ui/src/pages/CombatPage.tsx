import { useState, useEffect } from 'react';
import { useGame } from '../context/GameContext';
import { MonsterCard } from '../components/MonsterCard';
import { CombatPanel } from '../components/CombatPanel';
import { CombatStyleSelector, type WeaponType } from '../components/CombatStyleSelector';
import type { AreaId, MonsterId, CombatStyle, GameDefs, EquipmentState, DungeonId } from '../shared/types';

const DEFAULT_STYLE: Record<WeaponType, CombatStyle> = {
  melee: 'melee-attack',
  ranged: 'ranged',
  magic: 'magic',
};

function getWeaponType(equipment: EquipmentState | undefined, defs: GameDefs): WeaponType {
  const weaponId = equipment?.slots?.weapon;
  if (!weaponId) return 'melee';
  const stats = defs.equipmentStats[weaponId];
  if (!stats) return 'melee';
  if (stats.rangedAttackBonus > 0) return 'ranged';
  if (stats.magicAttackBonus > 0) return 'magic';
  return 'melee';
}

export function CombatPage() {
  const { defs, state, startCombat, stopCombat, drinkPotion, specialAttack, togglePrayer, getSlayerTask, startDungeon } = useGame();
  const [selectedArea, setSelectedArea] = useState<AreaId | null>(null);
  const [selectedMonster, setSelectedMonster] = useState<MonsterId | null>(null);
  const [selectedStyle, setSelectedStyle] = useState<CombatStyle>('melee-attack');
  const [selectedTab, setSelectedTab] = useState<'areas' | 'dungeons' | 'prayers'>('areas');

  const weaponType = defs && state ? getWeaponType(state.equipment, defs) : 'melee';

  // Auto-select a valid style when weapon type changes
  useEffect(() => {
    setSelectedStyle((prev) => {
      const melee: CombatStyle[] = ['melee-attack', 'melee-strength', 'melee-defence'];
      if (weaponType === 'melee' && melee.includes(prev)) return prev;
      if (weaponType === 'ranged' && prev === 'ranged') return prev;
      if (weaponType === 'magic' && prev === 'magic') return prev;
      return DEFAULT_STYLE[weaponType];
    });
  }, [weaponType]);

  if (!defs || !state) return null;

  const isCombatActive = state.activeAction?.type === 'combat' || state.activeAction?.type === 'dungeon';
  const combatAction = isCombatActive ? state.activeAction : null;

  const areas = Object.entries(defs.areas).sort((a, b) => a[1].levelReq - b[1].levelReq);

  const handleFight = () => {
    if (selectedArea && selectedMonster) {
      startCombat(selectedArea, selectedMonster, selectedStyle);
    }
  };

  // Compute player weapon speed for attack timer bar
  const getWeaponSpeed = (): number => {
    const weaponId = state.equipment?.slots?.weapon;
    if (!weaponId) return 2400; // unarmed kick
    const stats = defs.equipmentStats[weaponId];
    return stats?.attackSpeed || 2400;
  };

  // If combat is active, show the combat panel
  if (isCombatActive && combatAction && (combatAction.type === 'combat' || combatAction.type === 'dungeon')) {
    const monsterDef = defs.monsters[combatAction.monster];
    const title = combatAction.type === 'dungeon' ? `Dungeon: ${defs.dungeons?.[combatAction.dungeon]?.name ?? combatAction.dungeon}` : 'Combat';
    return (
      <div className="p-6 max-w-4xl">
        <div className="flex items-center justify-between mb-6">
          <h1 className="text-xl font-semibold text-gray-100">{title}</h1>
          <button
            onClick={stopCombat}
            className="px-4 py-2 rounded-lg text-sm font-medium border border-red-500/40 text-red-400 hover:bg-red-500/10 transition-colors cursor-pointer"
          >
            Flee
          </button>
        </div>
        <CombatPanel
          combatAction={combatAction}
          monsterDef={monsterDef}
          playerHp={state.hp}
          playerHpMax={state.hpMax}
          prayerPoints={state.prayerPoints ?? 0}
          prayerMax={state.prayerMax ?? 0}
          weaponSpeed={getWeaponSpeed()}
          activePotions={state.activePotions ?? []}
          activePrayers={state.activePrayers ?? []}
          bank={state.bank}
          defs={defs}
          onDrinkPotion={drinkPotion}
          onSpecialAttack={specialAttack}
          onTogglePrayer={togglePrayer}
        />
      </div>
    );
  }

  const slayerTask = state.slayerTask;
  const activePrayers = state.activePrayers ?? [];
  const prayerLevel = state.skills?.prayer?.level ?? 1;

  const dungeons = defs.dungeons ? Object.entries(defs.dungeons).sort((a, b) => a[1].levelReq - b[1].levelReq) : [];

  const prayers = defs.prayers ? Object.entries(defs.prayers).sort((a, b) => a[1].levelReq - b[1].levelReq) : [];

  const handleStartDungeon = (dungeonId: DungeonId) => {
    startDungeon(dungeonId, selectedStyle);
  };

  const tabs = [
    { id: 'areas' as const, label: 'Areas' },
    { id: 'dungeons' as const, label: 'Dungeons' },
    { id: 'prayers' as const, label: 'Prayers' },
  ];

  return (
    <div className="p-6 max-w-4xl">
      <h1 className="text-xl font-semibold text-gray-100 mb-6">Combat</h1>

      {/* Slayer task */}
      <div className="mb-6 bg-[#111827] border border-[#374151] rounded-lg px-5 py-4">
        <div className="flex items-center justify-between mb-2">
          <span className="text-sm font-semibold text-gray-400">Slayer Task</span>
          <button
            onClick={getSlayerTask}
            disabled={!!slayerTask}
            className="px-3 py-1 rounded text-xs font-medium border transition-colors cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed bg-orange-500/10 border-orange-500/30 text-orange-400 hover:bg-orange-500/20"
          >
            {slayerTask ? 'Task Active' : 'Get Task'}
          </button>
        </div>
        {slayerTask ? (
          <div>
            <div className="flex items-center justify-between text-sm mb-1">
              <span className="text-gray-300">{defs.monsters[slayerTask.monster]?.name ?? slayerTask.monster}</span>
              <span className="text-gray-400">{slayerTask.qtyRemaining}/{slayerTask.qtyTotal}</span>
            </div>
            <div className="h-2 bg-[#1f2937] rounded-full overflow-hidden">
              <div
                className="h-full rounded-full bg-orange-500 transition-all duration-300"
                style={{ width: ((slayerTask.qtyTotal - slayerTask.qtyRemaining) / slayerTask.qtyTotal * 100) + '%' }}
              />
            </div>
          </div>
        ) : (
          <p className="text-sm text-gray-500">No active task. Get one from the slayer master.</p>
        )}
      </div>

      {/* Combat style selector */}
      <div className="mb-6">
        <CombatStyleSelector selected={selectedStyle} onSelect={setSelectedStyle} weaponType={weaponType} />
      </div>

      {/* Tab selector */}
      <div className="flex gap-1 mb-6 bg-[#111827] rounded-lg p-1 border border-[#374151]">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setSelectedTab(tab.id)}
            className={`flex-1 py-2 rounded-md text-sm font-medium transition-colors cursor-pointer ${
              selectedTab === tab.id
                ? 'bg-[#1f2937] text-gray-100'
                : 'text-gray-500 hover:text-gray-300'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Areas tab */}
      {selectedTab === 'areas' && (
        <>
          <div className="space-y-6">
            {areas.map(([areaId, area]) => {
              const isSelected = selectedArea === areaId;
              return (
                <div key={areaId}>
                  <button
                    onClick={() => {
                      setSelectedArea(isSelected ? null : areaId);
                      setSelectedMonster(null);
                    }}
                    className={`w-full text-left px-4 py-3 rounded-lg border transition-colors cursor-pointer ${
                      isSelected
                        ? 'bg-[#1f2937] border-amber-600/50 text-gray-100'
                        : 'bg-[#111827] border-[#374151] text-gray-300 hover:border-gray-500'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <span className="font-medium">{area.name}</span>
                      <span className="text-xs text-gray-500">Level {area.levelReq}+</span>
                    </div>
                  </button>

                  {isSelected && (
                    <div className="mt-3 grid grid-cols-1 sm:grid-cols-2 gap-3 pl-2">
                      {area.monsters.map((monsterId) => {
                        const monster = defs.monsters[monsterId];
                        if (!monster) return null;
                        const isMonsterSelected = selectedMonster === monsterId;
                        return (
                          <MonsterCard
                            key={monsterId}
                            monsterId={monsterId}
                            monster={monster}
                            selected={isMonsterSelected}
                            onSelect={() => setSelectedMonster(isMonsterSelected ? null : monsterId)}
                            defs={defs}
                          />
                        );
                      })}
                    </div>
                  )}
                </div>
              );
            })}
          </div>

          {/* Fight button */}
          {selectedArea && selectedMonster && (
            <div className="mt-6">
              <button
                onClick={handleFight}
                className="w-full py-3 rounded-lg bg-amber-600 hover:bg-amber-500 text-gray-100 font-semibold text-sm transition-colors shadow-lg shadow-amber-600/25 cursor-pointer"
              >
                Fight {defs.monsters[selectedMonster]?.name ?? selectedMonster}
              </button>
            </div>
          )}
        </>
      )}

      {/* Dungeons tab */}
      {selectedTab === 'dungeons' && (
        <div className="space-y-4">
          {dungeons.length === 0 && (
            <p className="text-sm text-gray-500">No dungeons available.</p>
          )}
          {dungeons.map(([dungeonId, dungeon]) => (
            <div key={dungeonId} className="bg-[#111827] border border-[#374151] rounded-lg p-5">
              <div className="flex items-center justify-between mb-3">
                <span className="font-medium text-gray-200">{dungeon.name}</span>
                <span className="text-xs text-gray-500">Level {dungeon.levelReq}+</span>
              </div>
              <div className="text-xs text-gray-500 mb-3">
                {dungeon.rooms.length} rooms: {dungeon.rooms.map((r) => {
                  const mName = defs.monsters[r.monster]?.name ?? r.monster;
                  return `${mName} x${r.qty}`;
                }).join(' → ')}
              </div>
              {dungeon.rewardTable.length > 0 && (
                <div className="text-xs text-gray-500 mb-3">
                  Rewards: {dungeon.rewardTable.map((l) => defs.items[l.item]?.name ?? l.item).join(', ')}
                </div>
              )}
              <button
                onClick={() => handleStartDungeon(dungeonId)}
                className="w-full py-2 rounded-lg bg-purple-600 hover:bg-purple-500 text-gray-100 font-semibold text-sm transition-colors cursor-pointer"
              >
                Enter Dungeon
              </button>
            </div>
          ))}
        </div>
      )}

      {/* Prayers tab */}
      {selectedTab === 'prayers' && (
        <div className="space-y-2">
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm text-gray-400">
              Prayer Points: <span className="text-cyan-400">{state.prayerPoints ?? 0}/{state.prayerMax ?? 0}</span>
            </span>
            <span className="text-sm text-gray-400">
              Prayer Level: <span className="text-gray-200">{prayerLevel}</span>
            </span>
          </div>
          {prayers.length === 0 && (
            <p className="text-sm text-gray-500">No prayers available.</p>
          )}
          {prayers.map(([prayerId, prayer]) => {
            const isActive = activePrayers.includes(prayerId);
            const locked = prayerLevel < prayer.levelReq;
            return (
              <button
                key={prayerId}
                onClick={() => !locked && togglePrayer(prayerId)}
                disabled={locked}
                className={`w-full text-left px-4 py-3 rounded-lg border transition-colors cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed ${
                  isActive
                    ? 'bg-cyan-500/10 border-cyan-500/40 text-cyan-300'
                    : 'bg-[#111827] border-[#374151] text-gray-300 hover:border-gray-500'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span className="font-medium">{prayer.name}</span>
                  <div className="flex items-center gap-3 text-xs text-gray-500">
                    <span>Level {prayer.levelReq}</span>
                    <span>Drain: {prayer.drainPerAttack}/atk</span>
                    {isActive && <span className="text-cyan-400 font-medium">Active</span>}
                  </div>
                </div>
              </button>
            );
          })}
        </div>
      )}
    </div>
  );
}
