import { useRef, useEffect } from 'react';
import type { ActiveCombatAction, ActiveDungeonAction, MonsterDef, PotionEffect, ItemId, GameDefs, PrayerId } from '../shared/types';
import { GameIcon } from './ui/GameIcon';
import { fmt } from '../shared/format';

interface CombatPanelProps {
  combatAction: ActiveCombatAction | ActiveDungeonAction;
  monsterDef: MonsterDef;
  playerHp: number;
  playerHpMax: number;
  prayerPoints: number;
  prayerMax: number;
  prayerLevel: number;
  weaponSpeed: number;
  activePotions: PotionEffect[];
  activePrayers: PrayerId[];
  bank: Record<ItemId, number>;
  defs: GameDefs;
  onDrinkPotion: (item: ItemId) => void;
  onSpecialAttack: () => void;
  onTogglePrayer: (prayer: PrayerId) => void;
}

export function CombatPanel({ combatAction, monsterDef, playerHp, playerHpMax, prayerPoints, prayerMax, prayerLevel, weaponSpeed, activePotions, activePrayers, bank, defs, onDrinkPotion, onSpecialAttack, onTogglePrayer }: CombatPanelProps) {
  const enemyDmgRef = useRef<HTMLDivElement | null>(null);
  const playerDmgRef = useRef<HTMLDivElement | null>(null);

  // Counter-based attack detection (also drives timer bar resets)
  const prevPAtkRef = useRef(combatAction.playerAtkCount);
  const prevEAtkRef = useRef(combatAction.enemyAtkCount);

  // Detect attacks via monotonic counters and show damage splats
  useEffect(() => {
    if (combatAction.playerAtkCount > prevPAtkRef.current) {
      const dmg = combatAction.playerLastDmg;
      showSplat(enemyDmgRef.current, dmg, dmg > 0 ? '#f59e0b' : '#6b7280');
    }
    if (combatAction.enemyAtkCount > prevEAtkRef.current) {
      const dmg = combatAction.enemyLastDmg;
      showSplat(playerDmgRef.current, dmg, dmg > 0 ? '#ef4444' : '#6b7280');
    }
    prevPAtkRef.current = combatAction.playerAtkCount;
    prevEAtkRef.current = combatAction.enemyAtkCount;
  }, [combatAction.playerAtkCount, combatAction.enemyAtkCount,
      combatAction.playerLastDmg, combatAction.enemyLastDmg]);

  const enemyHpPct = monsterDef
    ? Math.max(0, Math.min(100, (combatAction.enemyHp / combatAction.enemyMaxHp) * 100))
    : 0;
  const playerHpPct = playerHpMax > 0 ? Math.max(0, Math.min(100, (playerHp / playerHpMax) * 100)) : 100;

  // Attack timer percentages
  const pTimer = combatAction.playerAttackTimer;
  const eTimer = combatAction.enemyAttackTimer;
  const pTimerPct = weaponSpeed > 0 ? Math.min(100, (pTimer / weaponSpeed) * 100) : 0;
  const eTimerPct = monsterDef.attackSpeed > 0 ? Math.min(100, (eTimer / monsterDef.attackSpeed) * 100) : 0;

  // Detect reset via counter increment (independent per combatant)
  const pTimerReset = combatAction.playerAtkCount !== prevPAtkRef.current;
  const eTimerReset = combatAction.enemyAtkCount !== prevEAtkRef.current;

  const effectivePTimerPct = pTimerReset ? 0 : pTimerPct;
  const effectiveETimerPct = eTimerReset ? 0 : eTimerPct;

  // Available potions in bank
  const bankPotions = Object.entries(bank)
    .filter(([id, qty]) => qty > 0 && defs.potions[id])
    .map(([id, qty]) => ({ id, qty, def: defs.potions[id], name: defs.items[id]?.name ?? id }));

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
      {/* Player */}
      <div className="bg-[#111827] border border-[#1e293b] rounded-lg p-5">
        <div className="text-sm font-semibold text-gray-400 mb-1">You</div>
        <div className="relative">
          <div className="flex items-center justify-between text-sm mb-1">
            <span className="text-gray-400">HP</span>
            <span className="text-gray-200">{fmt(playerHp)} / {fmt(playerHpMax)}</span>
          </div>
          <div className="h-4 bg-[#0d1117] rounded-full overflow-hidden">
            <div
              className="h-full rounded-full transition-all duration-300"
              style={{
                width: playerHpPct + '%',
                background: playerHpPct > 50 ? '#22c55e' : playerHpPct > 25 ? '#f59e0b' : '#ef4444',
              }}
            />
          </div>
          <div ref={playerDmgRef} className="absolute -top-2 right-0 text-sm font-bold opacity-0 pointer-events-none" />
        </div>
        {/* Player attack timer */}
        <div className="mt-3">
          <div className="flex items-center justify-between text-xs mb-1">
            <span className="text-gray-500">Attack</span>
            <span className="text-gray-500 tabular-nums">{(weaponSpeed / 1000).toFixed(1)}s</span>
          </div>
          <div className="h-2 bg-[#0d1117] rounded-full overflow-hidden">
            <div
              className="h-full rounded-full bg-amber-500"
              style={{
                width: effectivePTimerPct + '%',
                transition: pTimerReset ? 'none' : 'width 1s linear',
              }}
            />
          </div>
        </div>
        <div className="mt-2 text-xs text-gray-500">
          Style: <span className="text-gray-400">{formatStyle(combatAction.style)}</span>
        </div>
        {/* Special energy bar */}
        <div className="mt-3">
          <div className="flex items-center justify-between text-xs mb-1">
            <span className="text-gray-500">Special</span>
            <span className="text-gray-500 tabular-nums">{combatAction.specialEnergy}%</span>
          </div>
          <div className="h-2 bg-[#0d1117] rounded-full overflow-hidden">
            <div className="h-full rounded-full bg-yellow-500 transition-all duration-300" style={{ width: combatAction.specialEnergy + '%' }} />
          </div>
          <button
            onClick={onSpecialAttack}
            disabled={combatAction.specialQueued || combatAction.specialEnergy < 25}
            className="mt-1.5 px-3 py-1 rounded text-xs font-medium border transition-colors cursor-pointer disabled:opacity-40 disabled:cursor-not-allowed bg-yellow-500/10 border-yellow-500/30 text-yellow-400 hover:bg-yellow-500/20"
          >
            {combatAction.specialQueued ? 'Queued' : 'Special Attack'}
          </button>
        </div>
        {/* Prayer points */}
        {prayerMax > 0 && (
          <div className="mt-3">
            <div className="flex items-center justify-between text-xs mb-1">
              <span className="text-gray-500">Prayer</span>
              <span className="text-gray-500 tabular-nums">{prayerPoints}/{prayerMax}</span>
            </div>
            <div className="h-2 bg-[#0d1117] rounded-full overflow-hidden">
              <div className="h-full rounded-full bg-cyan-500 transition-all duration-300" style={{ width: prayerMax > 0 ? (prayerPoints / prayerMax * 100) + '%' : '0%' }} />
            </div>
          </div>
        )}
        {/* Active buff indicators */}
        {(activePotions.length > 0 || activePrayers.length > 0) && (
          <div className="mt-3 flex flex-wrap gap-2">
            {activePotions.map((pe, i) => {
              const pd = defs.potions[pe.item];
              if (!pd) return null;
              return (
                <span key={'pot-' + i} className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs bg-purple-500/20 text-purple-300 border border-purple-500/30">
                  {formatEffectType(pd.effectType)} +{pd.magnitude}%
                  <span className="text-purple-400/60">{pe.turnsLeft}</span>
                </span>
              );
            })}
            {activePrayers.map((pid) => {
              const pd = defs.prayers?.[pid];
              return (
                <span key={'pray-' + pid} className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs bg-cyan-500/20 text-cyan-300 border border-cyan-500/30 cursor-pointer hover:bg-cyan-500/30" onClick={() => onTogglePrayer(pid)}>
                  {pd?.name ?? pid}
                </span>
              );
            })}
          </div>
        )}
      </div>

      {/* Enemy */}
      <div className="bg-[#111827] border border-[#1e293b] rounded-lg p-5">
        <div className="flex items-center gap-3 mb-2">
          <GameIcon category="monster" id={combatAction.monster} size={48} fallback={monsterDef?.name?.charAt(0) ?? '?'} />
          <div className="text-sm font-semibold text-red-400">{monsterDef?.name ?? combatAction.monster}</div>
        </div>
        <div className="relative">
          <div className="flex items-center justify-between text-sm mb-1">
            <span className="text-gray-400">HP</span>
            <span className="text-gray-200">{fmt(combatAction.enemyHp)} / {fmt(combatAction.enemyMaxHp)}</span>
          </div>
          <div className="h-4 bg-[#0d1117] rounded-full overflow-hidden">
            <div
              className="h-full bg-red-500 rounded-full transition-all duration-300"
              style={{ width: enemyHpPct + '%' }}
            />
          </div>
          <div ref={enemyDmgRef} className="absolute -top-2 right-0 text-sm font-bold opacity-0 pointer-events-none" />
        </div>
        {/* Enemy attack timer */}
        <div className="mt-3">
          <div className="flex items-center justify-between text-xs mb-1">
            <span className="text-gray-500">Attack</span>
            <span className="text-gray-500 tabular-nums">{(monsterDef.attackSpeed / 1000).toFixed(1)}s</span>
          </div>
          <div className="h-2 bg-[#0d1117] rounded-full overflow-hidden">
            <div
              className="h-full rounded-full bg-red-500"
              style={{
                width: effectiveETimerPct + '%',
                transition: eTimerReset ? 'none' : 'width 1s linear',
              }}
            />
          </div>
        </div>
      </div>

      {/* Kill count + dungeon progress */}
      <div className="md:col-span-2 bg-[#111827] border border-[#1e293b] rounded-lg px-5 py-3">
        <div className="flex items-center justify-between">
          <span className="text-sm text-gray-400">Kills</span>
          <span className="text-lg font-semibold text-amber-500">{fmt(combatAction.kills)}</span>
        </div>
        {combatAction.type === 'dungeon' && defs.dungeons && (
          <div className="mt-2 flex items-center justify-between text-sm">
            <span className="text-gray-400">
              Room {combatAction.roomIdx + 1}/{defs.dungeons[combatAction.dungeon]?.rooms?.length ?? '?'}
            </span>
            <span className="text-gray-400">
              {combatAction.roomKills}/{defs.dungeons[combatAction.dungeon]?.rooms?.[combatAction.roomIdx]?.qty ?? '?'} cleared
            </span>
          </div>
        )}
      </div>

      {/* Potions */}
      {bankPotions.length > 0 && (
        <div className="md:col-span-2 bg-[#111827] border border-[#1e293b] rounded-lg px-5 py-4">
          <div className="text-sm font-semibold text-gray-400 mb-3">Potions</div>
          <div className="flex flex-wrap gap-2">
            {bankPotions.map(({ id, qty, def, name }) => (
              <button
                key={id}
                onClick={() => onDrinkPotion(id)}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors cursor-pointer bg-[#0d1117] border-[#1e293b] text-gray-300 hover:border-purple-500/50 hover:text-purple-300"
              >
                {name}
                <span className="text-gray-500">x{qty}</span>
                <span className="text-gray-600">
                  {def.effectType === 'heal' ? `+${def.magnitude} HP` : `+${def.magnitude}%`}
                </span>
              </button>
            ))}
          </div>
        </div>
      )}

      {/* Prayers */}
      {defs.prayers && Object.keys(defs.prayers).length > 0 && (
        <div className="md:col-span-2 bg-[#111827] border border-[#1e293b] rounded-lg px-5 py-4">
          <div className="flex items-center justify-between mb-3">
            <span className="text-sm font-semibold text-gray-400">Prayers</span>
            <span className="text-xs text-gray-500">
              Points: <span className="text-cyan-400">{prayerPoints}/{prayerMax}</span>
            </span>
          </div>
          <div className="flex flex-wrap gap-2">
            {Object.entries(defs.prayers)
              .sort((a, b) => a[1].levelReq - b[1].levelReq)
              .map(([prayerId, prayer]) => {
                const isActive = activePrayers.includes(prayerId);
                const locked = prayerLevel < prayer.levelReq;
                return (
                  <button
                    key={prayerId}
                    onClick={() => !locked && onTogglePrayer(prayerId)}
                    disabled={locked}
                    className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium border transition-colors cursor-pointer disabled:opacity-30 disabled:cursor-not-allowed ${
                      isActive
                        ? 'bg-cyan-500/20 border-cyan-500/40 text-cyan-300'
                        : 'bg-[#0d1117] border-[#1e293b] text-gray-300 hover:border-cyan-500/50 hover:text-cyan-300'
                    }`}
                  >
                    {prayer.name}
                    <span className="text-gray-600">Lv{prayer.levelReq}</span>
                    {isActive && <span className="text-cyan-400">ON</span>}
                  </button>
                );
              })}
          </div>
        </div>
      )}
    </div>
  );
}

function formatStyle(style: string): string {
  return style
    .split('-')
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1))
    .join(' ');
}

function formatEffectType(et: string): string {
  switch (et) {
    case 'attack-boost': return 'Atk';
    case 'strength-boost': return 'Str';
    case 'defence-boost': return 'Def';
    default: return et;
  }
}

function showSplat(el: HTMLDivElement | null, dmg: number, color: string) {
  if (!el) return;
  el.textContent = dmg === 0 ? '0' : '-' + dmg;
  el.style.color = color;
  el.style.opacity = '1';
  el.style.transform = 'translateY(0)';
  el.style.transition = 'none';
  // Force reflow
  void el.offsetHeight;
  el.style.transition = 'all 0.8s ease-out';
  el.style.opacity = '0';
  el.style.transform = 'translateY(-20px)';
}
