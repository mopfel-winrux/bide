import { useGame } from '../context/GameContext';
import type { SkillId } from '../shared/types';

const AGILITY_MILESTONES = [
  { level: 10, desc: '+2% Woodcutting XP' },
  { level: 20, desc: '+2% Mining XP' },
  { level: 30, desc: '+2% Fishing XP' },
  { level: 40, desc: '+3% Thieving XP' },
  { level: 50, desc: '-5% Action Time (all skills)' },
  { level: 60, desc: '+3% Combat XP' },
  { level: 70, desc: '+5% Farming Yield' },
  { level: 80, desc: '-5% More Action Time (-10% total)' },
  { level: 90, desc: '+5% All Skill XP' },
];

const ASTROLOGY_GLOBAL = [
  { level: 25, desc: '+1% All XP' },
  { level: 50, desc: '+2% More All XP (+3% total)' },
  { level: 75, desc: '+1% More All XP (+4% total)' },
  { level: 99, desc: '+2% More All XP (+6% total)' },
];

const ASTROLOGY_MASTERY = [
  { xp: 100, desc: '+1% XP to linked skill' },
  { xp: 500, desc: '+2% more (+3% total)' },
  { xp: 2000, desc: '+3% more (+6% total)' },
];

interface Props {
  skillId: SkillId;
}

export function SkillBonuses({ skillId }: Props) {
  const { defs, getDisplaySkill } = useGame();

  if (skillId === 'agility') {
    const ds = getDisplaySkill('agility');
    return (
      <div className="mb-6 bg-[#111827] border border-[#1e293b] rounded-lg p-4">
        <h3 className="text-sm font-semibold text-gray-400 mb-3">Milestones</h3>
        <div className="space-y-1.5">
          {AGILITY_MILESTONES.map((m) => {
            const unlocked = ds.level >= m.level;
            return (
              <div key={m.level} className={`flex items-center gap-3 text-sm ${unlocked ? 'text-gray-200' : 'text-gray-600'}`}>
                <span className={`w-12 text-right font-medium ${unlocked ? 'text-amber-500' : 'text-gray-600'}`}>
                  Lv {m.level}
                </span>
                <span>{m.desc}</span>
                {unlocked && <span className="text-green-500 text-xs">Active</span>}
              </div>
            );
          })}
        </div>
      </div>
    );
  }

  if (skillId === 'astrology') {
    const ds = getDisplaySkill('astrology');
    return (
      <div className="mb-6 bg-[#111827] border border-[#1e293b] rounded-lg p-4">
        <h3 className="text-sm font-semibold text-gray-400 mb-3">Level Bonuses</h3>
        <div className="space-y-1.5 mb-4">
          {ASTROLOGY_GLOBAL.map((m) => {
            const unlocked = ds.level >= m.level;
            return (
              <div key={m.level} className={`flex items-center gap-3 text-sm ${unlocked ? 'text-gray-200' : 'text-gray-600'}`}>
                <span className={`w-12 text-right font-medium ${unlocked ? 'text-amber-500' : 'text-gray-600'}`}>
                  Lv {m.level}
                </span>
                <span>{m.desc}</span>
                {unlocked && <span className="text-green-500 text-xs">Active</span>}
              </div>
            );
          })}
        </div>
        <h3 className="text-sm font-semibold text-gray-400 mb-3">Mastery Bonuses (per constellation)</h3>
        <div className="space-y-1.5 mb-4">
          {ASTROLOGY_MASTERY.map((m) => (
            <div key={m.xp} className="flex items-center gap-3 text-sm text-gray-400">
              <span className="w-16 text-right font-medium text-purple-400">{m.xp} XP</span>
              <span>{m.desc}</span>
            </div>
          ))}
        </div>
        {defs && (
          <>
            <h3 className="text-sm font-semibold text-gray-400 mb-3">Constellations</h3>
            <div className="grid grid-cols-2 gap-1.5">
              {Object.entries(defs.constellations).map(([actionId, linkedSkill]) => {
                const skillName = defs.skills[linkedSkill]?.name ?? linkedSkill;
                return (
                  <div key={actionId} className="text-xs text-gray-500">
                    <span className="text-gray-400">{actionId.replace('study-', '').charAt(0).toUpperCase() + actionId.replace('study-', '').slice(1)}</span>
                    {' \u2192 '}
                    <span className="text-blue-400">{skillName}</span>
                  </div>
                );
              })}
            </div>
          </>
        )}
      </div>
    );
  }

  if (skillId === 'summoning' && defs) {
    return (
      <div className="mb-6 bg-[#111827] border border-[#1e293b] rounded-lg p-4">
        <h3 className="text-sm font-semibold text-gray-400 mb-3">Familiar Effects</h3>
        <div className="space-y-2">
          {Object.entries(defs.familiars).map(([tabletId, f]) => {
            const name = defs.items[tabletId]?.name ?? tabletId;
            const bonuses: string[] = [];
            if (f.gatheringXp > 0) bonuses.push(`+${f.gatheringXp}% Gathering XP`);
            if (f.artisanXp > 0) bonuses.push(`+${f.artisanXp}% Artisan XP`);
            if (f.thievingXp > 0) bonuses.push(`+${f.thievingXp}% Thieving XP`);
            if (f.herbloreXp > 0) bonuses.push(`+${f.herbloreXp}% Herblore XP`);
            if (f.combatXp > 0) bonuses.push(`+${f.combatXp}% Combat XP`);
            if (f.allXp > 0) bonuses.push(`+${f.allXp}% All XP`);
            if (f.atkBoost > 0) bonuses.push(`+${f.atkBoost}% Attack`);
            if (f.strBoost > 0) bonuses.push(`+${f.strBoost}% Strength`);
            if (f.defBoost > 0) bonuses.push(`+${f.defBoost}% Defence`);
            if (f.farmingYield > 0) bonuses.push(`+${f.farmingYield}% Farming Yield`);
            return (
              <div key={tabletId} className="flex items-center justify-between text-sm">
                <span className="text-gray-300">{name}</span>
                <span className="text-xs text-green-400">{bonuses.join(' | ')}</span>
              </div>
            );
          })}
        </div>
      </div>
    );
  }

  return null;
}
