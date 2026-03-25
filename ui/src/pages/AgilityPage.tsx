import { useState, useMemo } from 'react';
import { useGame } from '../context/GameContext';
import { XpBar } from '../components/ui/XpBar';
import { ActiveAction } from '../components/ActiveAction';
import { Button } from '../components/ui/Button';
import { GameIcon } from '../components/ui/GameIcon';
import { fmt, fmtTime } from '../shared/format';
import { getXpBonusPct, getSpeedBonusPct, applySpeedBonus } from '../shared/modifiers';
import type { ObstacleDef, AgilityModifier } from '../shared/types';

const SLOTS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const SLOT_LEVELS = [1, 10, 20, 30, 40, 50, 60, 70, 80, 90];

function modLabel(m: AgilityModifier): string {
  const pct = `${m.pct}%`;
  switch (m.type) {
    case 'xp-skill': return `${m.skill} XP ${pct}`;
    case 'xp-global': return `Global XP ${pct}`;
    case 'speed-bonus': return `Speed ${pct}`;
    case 'gp-bonus': return `GP ${pct}`;
    case 'farming-yield': return `Farming Yield ${pct}`;
    case 'preservation': return `Preservation ${pct}`;
    case 'atk-boost': return `Attack ${pct}`;
    case 'str-boost': return `Strength ${pct}`;
    case 'def-boost': return `Defence ${pct}`;
    case 'ranged-boost': return `Ranged ${pct}`;
    case 'magic-boost': return `Magic ${pct}`;
    case 'hp-bonus': return `HP ${pct}`;
    default: return `${m.type} ${pct}`;
  }
}

export function AgilityPage() {
  const { defs, state, getDisplaySkill, startAction, stopAction, buildObstacle, destroyObstacle, setAgilityPillar, agilitySlot } = useGame();
  const [expandedSlot, setExpandedSlot] = useState<number | null>(null);

  if (!defs || !state) return null;

  const ds = getDisplaySkill('agility');
  const course = state.agilityCourse ?? {};
  const activePillar = state.activePillar;
  const gp = state.gp;
  const bank = state.bank;

  const aa = state.activeAction;
  const isTraining = aa?.type === 'skilling' && aa.skill === 'agility';

  // Group obstacles by slot
  const obstaclesBySlot = useMemo(() => {
    const map: Record<number, ObstacleDef[]> = {};
    if (defs.obstacles) {
      for (const o of Object.values(defs.obstacles)) {
        if (!map[o.slot]) map[o.slot] = [];
        map[o.slot].push(o);
      }
      for (const slot of Object.keys(map)) {
        map[Number(slot)].sort((a, b) => a.xp - b.xp);
      }
    }
    return map;
  }, [defs.obstacles]);

  // Find highest contiguous slot for chain display
  let chainLength = 0;
  for (let s = 1; s <= 10; s++) {
    if (course[String(s)]) chainLength = s;
    else break;
  }

  // Course totals
  const totalXp = useMemo(() => {
    let xp = 0;
    for (let s = 1; s <= chainLength; s++) {
      const oid = course[String(s)];
      if (oid && defs.obstacles?.[oid]) xp += defs.obstacles[oid].xp;
    }
    return xp;
  }, [course, chainLength, defs.obstacles]);

  const totalInterval = useMemo(() => {
    let ms = 0;
    for (let s = 1; s <= chainLength; s++) {
      const oid = course[String(s)];
      if (oid && defs.obstacles?.[oid]) ms += defs.obstacles[oid].interval;
    }
    return ms;
  }, [course, chainLength, defs.obstacles]);

  // XP/hr with modifiers
  const courseInterval = Number(state.agilityCourseInterval) || totalInterval || 0;
  const courseXp = Number(state.agilityCourseXp) || totalXp || 0;
  const xpPct = getXpBonusPct(state.modifiers, 'agility', defs.skills['agility']?.type);
  const speedPct = getSpeedBonusPct(state.modifiers);
  const modifiedXp = courseXp + Math.floor(courseXp * xpPct / 100);
  const adjustedInterval = applySpeedBonus(courseInterval, speedPct);
  const xpPerHour = adjustedInterval > 0 ? Math.round((modifiedXp / adjustedInterval) * 3_600_000) : 0;

  const canTrain = chainLength > 0;

  return (
    <div>
      <div className="flex items-center gap-4 mb-6">
        <GameIcon category="skill-icon" id="agility" size={40} />
        <h1 className="text-2xl font-bold">Agility</h1>
        <div className="text-base text-gray-400">
          Level <span className="text-gray-100 font-semibold">{ds.level}</span>
        </div>
      </div>

      <XpBar xp={ds.xp} level={ds.level} className="mb-4" />

      <ActiveAction />

      {/* Course summary + training */}
      {canTrain && (
        <div className="mb-6 bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-3">
          <div className="flex items-center justify-between">
            <div className="text-sm text-gray-300 space-x-4">
              <span>XP/run: <span className="text-emerald-400 font-medium">{fmt(modifiedXp || 0)}</span></span>
              <span>GP/run: <span className="text-yellow-500 font-medium">{fmt(Number(state.agilityCourseGp) || 0)}</span></span>
              <span>Time: <span className="text-gray-200">{fmtTime(totalInterval)}</span></span>
              <span>XP/hr: <span className="text-amber-400 font-medium">{fmt(xpPerHour || 0)}</span></span>
              <span>GP/hr: <span className="text-yellow-500 font-medium">{fmt(adjustedInterval > 0 ? Math.round(((Number(state.agilityCourseGp) || 0) / adjustedInterval) * 3_600_000) : 0)}</span></span>
            </div>
            {isTraining ? (
              <Button variant="danger" size="sm" onClick={stopAction}>Stop</Button>
            ) : (
              <Button variant="primary" size="sm" onClick={() => startAction('agility', 'run-course')}>
                Start Training
              </Button>
            )}
          </div>
        </div>
      )}

      {/* Course builder */}
      <h2 className="text-lg font-semibold mb-4">Obstacle Course</h2>
      <div className="space-y-3">
        {SLOTS.map((slot, idx) => {
          const levelReq = SLOT_LEVELS[idx];
          const unlocked = ds.level >= levelReq;
          const builtId = course[String(slot)];
          const builtDef = builtId ? defs.obstacles?.[builtId] : null;
          const isExpanded = expandedSlot === slot;
          const inChain = slot <= chainLength;
          const options = obstaclesBySlot[slot] ?? [];

          return (
            <div key={slot} className={`border rounded-lg transition-colors ${
              !unlocked ? 'border-[#1e293b] bg-[#0d1117] opacity-50' :
              isTraining && agilitySlot === slot ? 'border-amber-500 bg-amber-900/20 ring-1 ring-amber-500/30' :
              builtDef ? (inChain ? 'border-emerald-800/50 bg-[#111827]' : 'border-amber-800/30 bg-[#111827]') :
              'border-[#1e293b] bg-[#111827] border-dashed'
            }`}>
              <div
                className="px-4 py-3 flex items-center justify-between cursor-pointer"
                onClick={() => unlocked && setExpandedSlot(isExpanded ? null : slot)}
              >
                <div className="flex items-center gap-3">
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold ${
                    isTraining && agilitySlot === slot ? 'bg-amber-500 text-white animate-pulse' :
                    builtDef && inChain ? 'bg-emerald-600 text-white' :
                    builtDef ? 'bg-amber-600/50 text-amber-200' :
                    unlocked ? 'bg-[#1e293b] text-gray-400' :
                    'bg-[#0d1117] text-gray-600'
                  }`}>
                    {slot}
                  </div>
                  <div>
                    <div className="text-sm text-gray-200">
                      {builtDef ? builtDef.name : unlocked ? 'Empty Slot' : `Locked (Lv ${levelReq})`}
                    </div>
                    {builtDef && (
                      <div className="flex gap-3 text-[11px] mt-0.5">
                        {builtDef.bonuses.map((b, i) => (
                          <span key={i} className="text-green-400">+{modLabel(b)}</span>
                        ))}
                        {builtDef.penalties.map((p, i) => (
                          <span key={i} className="text-red-400">-{modLabel(p)}</span>
                        ))}
                      </div>
                    )}
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  {builtDef && (
                    <span className="text-[11px] text-gray-500">{fmt(builtDef.xp)} XP · {fmt(builtDef.gp)} GP · {fmtTime(builtDef.interval)}</span>
                  )}
                  {!builtDef && !inChain && slot > 1 && slot <= chainLength + 1 && unlocked && (
                    <span className="text-[11px] text-amber-500">Chain break</span>
                  )}
                </div>
              </div>

              {/* Expanded: show obstacle options */}
              {isExpanded && unlocked && (
                <div className="px-4 pb-4 border-t border-[#1e293b] pt-3">
                  {builtDef && (
                    <div className="mb-3">
                      <button
                        onClick={() => { destroyObstacle(slot); setExpandedSlot(null); }}
                        className="text-xs text-red-400 hover:text-red-300 cursor-pointer"
                      >
                        Destroy obstacle
                      </button>
                    </div>
                  )}
                  <div className="grid grid-cols-1 lg:grid-cols-3 gap-3">
                    {options.map((o) => {
                      const isBuilt = builtId === o.id;
                      const canAfford = gp >= o.gpCost && o.itemCosts.every(c => (bank[c.item] ?? 0) >= c.qty);
                      return (
                        <div key={o.id} className={`border rounded-lg p-3 ${
                          isBuilt ? 'border-emerald-600/50 bg-emerald-900/10' : 'border-[#1e293b]'
                        }`}>
                          <div className="text-sm font-medium text-gray-200 mb-1">{o.name}</div>
                          <div className="text-[11px] text-gray-500 mb-2">
                            {fmt(o.xp)} XP · {fmt(o.gp)} GP · {fmtTime(o.interval)}
                          </div>
                          <div className="space-y-0.5 text-[11px] mb-2">
                            {o.bonuses.map((b, i) => (
                              <div key={`b${i}`} className="text-green-400">+{modLabel(b)}</div>
                            ))}
                            {o.penalties.map((p, i) => (
                              <div key={`p${i}`} className="text-red-400">-{modLabel(p)}</div>
                            ))}
                          </div>
                          <div className="text-[11px] text-gray-500 mb-2">
                            <div>Cost: <span className={gp >= o.gpCost ? 'text-yellow-500' : 'text-red-400'}>{fmt(o.gpCost)} GP</span></div>
                            {o.itemCosts.map((c, i) => {
                              const have = bank[c.item] ?? 0;
                              const name = defs.items[c.item]?.name ?? c.item;
                              return (
                                <div key={i}>
                                  <span className={have >= c.qty ? 'text-gray-300' : 'text-red-400'}>
                                    {have}/{c.qty} {name}
                                  </span>
                                </div>
                              );
                            })}
                          </div>
                          {isBuilt ? (
                            <span className="text-[11px] text-emerald-400 font-medium">Built</span>
                          ) : (
                            <button
                              onClick={() => { buildObstacle(slot, o.id); setExpandedSlot(null); }}
                              disabled={!canAfford}
                              className={`px-3 py-1 rounded text-xs font-medium transition-colors ${
                                canAfford
                                  ? 'bg-amber-600 hover:bg-amber-500 text-gray-100 cursor-pointer'
                                  : 'bg-gray-700 text-gray-500 cursor-not-allowed'
                              }`}
                            >
                              Build
                            </button>
                          )}
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Passive Pillar (level 99) */}
      {ds.level >= 99 && defs.pillars && (
        <div className="mt-8">
          <h2 className="text-lg font-semibold mb-4">Passive Pillar</h2>
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-3">
            {Object.values(defs.pillars).map((p) => {
              const isActive = activePillar === p.id;
              return (
                <div key={p.id} className={`border rounded-lg p-4 ${
                  isActive ? 'border-amber-600/50 bg-amber-900/10' : 'border-[#1e293b] bg-[#111827]'
                }`}>
                  <div className="text-sm font-medium text-gray-200 mb-2">{p.name}</div>
                  <div className="space-y-0.5 text-[11px] mb-3">
                    {p.bonuses.map((b, i) => (
                      <div key={i} className="text-green-400">+{modLabel(b)}</div>
                    ))}
                  </div>
                  <div className="text-[11px] text-gray-500 mb-2">{fmt(p.gpCost)} GP</div>
                  {isActive ? (
                    <span className="text-xs text-amber-400 font-medium">Active</span>
                  ) : (
                    <button
                      onClick={() => setAgilityPillar(p.id)}
                      disabled={gp < p.gpCost}
                      className={`px-3 py-1 rounded text-xs font-medium transition-colors ${
                        gp >= p.gpCost
                          ? 'bg-amber-600 hover:bg-amber-500 text-gray-100 cursor-pointer'
                          : 'bg-gray-700 text-gray-500 cursor-not-allowed'
                      }`}
                    >
                      Activate
                    </button>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}
