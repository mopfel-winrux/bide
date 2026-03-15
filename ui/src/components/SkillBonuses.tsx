import { useGame } from '../context/GameContext';
import type { SkillId, ActionId } from '../shared/types';

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

const ASTROLOGY_GLOBAL = [
  { level: 25, desc: '+1% All XP' },
  { level: 50, desc: '+2% More All XP (+3% total)' },
  { level: 75, desc: '+1% More All XP (+4% total)' },
  { level: 99, desc: '+2% More All XP (+6% total)' },
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
  const { defs, state, getDisplaySkill, upgradeStar } = useGame();

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
        {defs && state && (
          <>
            <h3 className="text-sm font-semibold text-gray-400 mb-3">Constellations</h3>
            <div className="space-y-3">
              {Object.entries(defs.constellations).map(([actionId, linkedSkills]) => {
                const [s1, s2] = linkedSkills;
                const name1 = defs.skills[s1]?.name ?? s1;
                const name2 = defs.skills[s2]?.name ?? s2;
                const constellationName = actionId.replace('study-', '').charAt(0).toUpperCase() + actionId.replace('study-', '').slice(1);

                return (
                  <div key={actionId} className="bg-[#0d1117] border border-[#1e293b] rounded p-3">
                    <div className="flex items-center justify-between mb-2">
                      <span className="text-sm text-gray-300 font-medium">{constellationName}</span>
                      <span className="text-xs text-gray-500">
                        <span className="text-blue-400">{name1}</span>
                        {' / '}
                        <span className="text-blue-400">{name2}</span>
                      </span>
                    </div>
                    {defs.starDefs && (
                      <div className="flex gap-2">
                        {defs.starDefs.stars.map((star, idx) => {
                          const key = `${actionId}/${idx}`;
                          const level = state.starLevels?.[key] ?? 0;
                          const isMax = level >= star.maxLevel;
                          const cost = isMax ? null : star.costs[level];
                          const currencyName = defs.items[star.currency]?.name ?? star.currency;
                          const have = state.bank[star.currency] ?? 0;
                          const canAfford = cost !== null && have >= cost;
                          const typeLabel = star.type === 'xp-boost' ? 'XP' : 'Speed';
                          const bonusLabel = star.type === 'xp-boost'
                            ? `+${level}% XP`
                            : `+${level}% Speed`;

                          return (
                            <button
                              key={idx}
                              disabled={isMax || !canAfford}
                              onClick={() => upgradeStar(actionId as ActionId, idx)}
                              className={`flex-1 rounded p-2 text-xs text-center border transition-colors ${
                                isMax
                                  ? 'border-amber-700 bg-amber-900/20 text-amber-400 cursor-default'
                                  : canAfford
                                    ? 'border-blue-700 bg-blue-900/20 text-blue-300 hover:bg-blue-800/30 cursor-pointer'
                                    : 'border-gray-700 bg-gray-900/20 text-gray-600 cursor-not-allowed'
                              }`}
                              title={isMax ? `${typeLabel} star maxed` : `Cost: ${cost} ${currencyName}`}
                            >
                              <div className="font-medium">{typeLabel} {idx + 1}</div>
                              <div className="text-[10px] mt-0.5">
                                Lv {level}/{star.maxLevel}
                              </div>
                              <div className="text-[10px] mt-0.5">{bonusLabel}</div>
                              {!isMax && cost !== null && (
                                <div className={`text-[10px] mt-1 ${canAfford ? 'text-green-400' : 'text-red-400'}`}>
                                  {cost} {currencyName.split(' ')[0]}
                                </div>
                              )}
                            </button>
                          );
                        })}
                      </div>
                    )}
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
