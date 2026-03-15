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

const FIREMAKING_MILESTONES = [
  { sum: 18, pct: 1, desc: '+1% Global XP (avg mastery lv2)' },
  { sum: 45, pct: 2, desc: '+2% Global XP' },
  { sum: 90, pct: 3, desc: '+3% Global XP' },
  { sum: 270, pct: 5, desc: '+5% Global XP' },
  { sum: 450, pct: 8, desc: '+8% Global XP' },
  { sum: 891, pct: 12, desc: '+12% Global XP (all 99)' },
];

const ASTROLOGY_MASTERY = [
  { xp: 100, desc: '+1% XP to linked skills' },
  { xp: 500, desc: '+2% more (+3% total)' },
  { xp: 2000, desc: '+3% more (+6% total)' },
];

const XP_TABLE = [
  0,83,174,276,388,512,650,801,969,1154,1358,1584,1833,2107,2411,2746,3115,3523,3973,4470,
  5018,5624,6291,7028,7842,8740,9730,10824,12031,13363,14833,16456,18247,20224,22406,24815,
  27473,30408,33648,37224,41171,45529,50339,55649,61512,67983,75127,83014,91721,101333,
  111945,123660,136594,150872,166636,184040,203254,224466,247886,273742,302288,333804,
  368599,407015,449428,496254,547953,605032,668051,737627,814445,899257,992895,1096278,
  1210421,1336443,1475581,1629200,1798808,1986068,2192818,2421087,2673114,2951373,3258594,
  3597792,3972294,4385776,4842295,5346332,5902831,6517253,7195629,7944614,8771558,9684577,
  10692629,11805606,13034431,
];

function levelFromXp(xp: number): number {
  for (let i = XP_TABLE.length - 1; i >= 0; i--) {
    if (xp >= XP_TABLE[i]) return i + 1;
  }
  return 1;
}

interface Props {
  skillId: SkillId;
}

export function SkillBonuses({ skillId }: Props) {
  const { defs, state, getDisplaySkill } = useGame();

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

  if (skillId === 'firemaking') {
    const fmState = state?.skills?.firemaking;
    const masteryActions = fmState?.masteryActions ?? {};
    const masterySum = Object.values(masteryActions).reduce((sum, xp) => sum + levelFromXp(xp), 0);
    const currentBonus = FIREMAKING_MILESTONES.filter(m => masterySum >= m.sum).pop();
    return (
      <div className="mb-6 bg-[#111827] border border-[#1e293b] rounded-lg p-4">
        <h3 className="text-sm font-semibold text-gray-400 mb-3">
          Mastery Milestones
          <span className="text-xs text-gray-500 ml-2">(sum of mastery levels: {masterySum})</span>
        </h3>
        {currentBonus && (
          <div className="mb-3 text-sm text-green-400">
            Active: +{currentBonus.pct}% Global XP
          </div>
        )}
        <div className="space-y-1.5">
          {FIREMAKING_MILESTONES.map((m) => {
            const unlocked = masterySum >= m.sum;
            return (
              <div key={m.sum} className={`flex items-center gap-3 text-sm ${unlocked ? 'text-gray-200' : 'text-gray-600'}`}>
                <span className={`w-12 text-right font-medium ${unlocked ? 'text-amber-500' : 'text-gray-600'}`}>
                  {m.sum}
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
    return (
      <div className="mb-6 bg-[#111827] border border-[#1e293b] rounded-lg p-4">
        <h3 className="text-sm font-semibold text-gray-400 mb-3">Mastery Bonuses (per constellation)</h3>
        <div className="space-y-1.5">
          {ASTROLOGY_MASTERY.map((m) => (
            <div key={m.xp} className="flex items-center gap-3 text-sm text-gray-400">
              <span className="w-16 text-right font-medium text-purple-400">{m.xp} XP</span>
              <span>{m.desc}</span>
            </div>
          ))}
        </div>
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
