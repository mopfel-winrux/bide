import { useGame } from '../context/GameContext';
import { fmt } from '../shared/format';
import { levelFromXp } from '../shared/xp';

const MAX_LEVEL = 99;

export function CompletionPage() {
  const { defs, state } = useGame();

  if (!defs || !state) return null;

  const stats = state.stats;

  // --- Skills ---
  const skillEntries = Object.entries(defs.skills);
  const totalSkills = skillEntries.length;
  const skillsMaxed = skillEntries.filter(([sid]) => (state.skills[sid]?.level ?? 1) >= MAX_LEVEL).length;

  // --- Monsters ---
  const monsterEntries = Object.entries(defs.monsters);
  const totalMonsters = monsterEntries.length;
  const monstersKilled = stats?.monstersKilled ?? {};
  const uniqueMonstersKilled = monsterEntries.filter(([mid]) => (monstersKilled[mid] ?? 0) > 0).length;

  // --- Dungeons ---
  const dungeonEntries = Object.entries(defs.dungeons ?? {});
  const totalDungeons = dungeonEntries.length;
  const dungeonsCompleted = stats?.dungeonsCompleted ?? {};
  const uniqueDungeonsCleared = dungeonEntries.filter(([did]) => (dungeonsCompleted[did] ?? 0) > 0).length;

  // --- Pets ---
  const petEntries = Object.entries(defs.pets ?? {});
  const totalPets = petEntries.length;
  const petsFound = state.petsFound ?? [];
  const petsFoundCount = petsFound.length;

  // --- Mastery ---
  // Count total mastery levels across all skills and actions
  let totalMasteryLevels = 0;
  let maxMasteryLevels = 0;
  let totalMasteryPoolXp = 0;
  const masteryBySkill: { sid: string; name: string; levels: number; maxLevels: number; poolXp: number }[] = [];
  for (const [sid, skillDef] of skillEntries) {
    const actionCount = skillDef.actions.filter(a => a.masteryXp > 0).length;
    if (actionCount === 0) continue;
    const ss = state.skills[sid];
    const masteryActions = ss?.masteryActions ?? {};
    const poolXp = ss?.poolXp ?? 0;
    let skillMasteryLevels = 0;
    for (const a of skillDef.actions) {
      if (a.masteryXp <= 0) continue;
      skillMasteryLevels += levelFromXp(masteryActions[a.id] ?? 0);
    }
    const skillMaxLevels = actionCount * 99;
    totalMasteryLevels += skillMasteryLevels;
    maxMasteryLevels += skillMaxLevels;
    totalMasteryPoolXp += poolXp;
    masteryBySkill.push({ sid, name: skillDef.name, levels: skillMasteryLevels, maxLevels: skillMaxLevels, poolXp });
  }

  // --- Overall completion ---
  const completionParts = [
    totalSkills > 0 ? skillsMaxed / totalSkills : 0,
    maxMasteryLevels > 0 ? totalMasteryLevels / maxMasteryLevels : 0,
    totalMonsters > 0 ? uniqueMonstersKilled / totalMonsters : 0,
    totalDungeons > 0 ? uniqueDungeonsCleared / totalDungeons : 0,
    totalPets > 0 ? petsFoundCount / totalPets : 0,
  ];
  const overallCompletion = completionParts.reduce((a, b) => a + b, 0) / completionParts.length * 100;

  // --- Aggregate stats ---
  const actionsCompleted = stats?.actionsCompleted ?? {};
  const totalActions = Object.values(actionsCompleted).reduce((a, b) => a + b, 0);
  const totalKills = Object.values(monstersKilled).reduce((a, b) => a + b, 0);

  return (
    <div className="p-6 max-w-4xl">
      <h1 className="text-xl font-semibold text-gray-100 mb-6">Completion Log</h1>

      {/* Overall Progress */}
      <div className="mb-8 bg-[#111827] border border-[#1e293b] rounded-lg p-5">
        <div className="flex items-center justify-between mb-3">
          <span className="text-sm font-semibold text-gray-400">Overall Progress</span>
          <span className="text-lg font-bold text-amber-400">{overallCompletion.toFixed(1)}%</span>
        </div>
        <div className="h-3 bg-[#0d1117] rounded-full overflow-hidden">
          <div
            className="h-full rounded-full bg-amber-500 transition-all duration-500"
            style={{ width: `${Math.min(overallCompletion, 100)}%` }}
          />
        </div>
        <div className="flex flex-wrap gap-6 mt-3 text-xs text-gray-500">
          <span>Skills: {skillsMaxed}/{totalSkills}</span>
          <span>Mastery: {totalMasteryLevels}/{maxMasteryLevels}</span>
          <span>Monsters: {uniqueMonstersKilled}/{totalMonsters}</span>
          <span>Dungeons: {uniqueDungeonsCleared}/{totalDungeons}</span>
          <span>Pets: {petsFoundCount}/{totalPets}</span>
        </div>
      </div>

      {/* Skills Section */}
      <div className="mb-8">
        <h2 className="text-lg font-semibold text-gray-100 mb-4">
          Skills
          <span className="ml-2 text-sm font-normal text-gray-500">
            {skillsMaxed}/{totalSkills} maxed
          </span>
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {skillEntries.map(([sid, skillDef]) => {
            const level = state.skills[sid]?.level ?? 1;
            const pct = (level / MAX_LEVEL) * 100;
            return (
              <div
                key={sid}
                className="bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-3"
              >
                <div className="flex items-center justify-between mb-1.5">
                  <span className="text-sm font-medium text-gray-200">{skillDef.name}</span>
                  <span className={`text-sm font-semibold ${level >= MAX_LEVEL ? 'text-amber-400' : 'text-gray-400'}`}>
                    {level}/{MAX_LEVEL}
                  </span>
                </div>
                <div className="h-2 bg-[#0d1117] rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all duration-300"
                    style={{
                      width: `${pct}%`,
                      backgroundColor: level >= MAX_LEVEL
                        ? '#f59e0b'
                        : level >= 75
                          ? '#22c55e'
                          : level >= 50
                            ? '#4ade80'
                            : level >= 25
                              ? '#86efac'
                              : '#bbf7d0',
                    }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Mastery Section */}
      {maxMasteryLevels > 0 && (
        <div className="mb-8">
          <h2 className="text-lg font-semibold text-gray-100 mb-4">
            Mastery
            <span className="ml-2 text-sm font-normal text-gray-500">
              {totalMasteryLevels}/{maxMasteryLevels} levels
            </span>
            <span className="ml-3 text-sm font-normal text-purple-400">
              Pool: {fmt(totalMasteryPoolXp)} XP
            </span>
          </h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {masteryBySkill.map(({ sid, name, levels, maxLevels, poolXp }) => {
              const pct = maxLevels > 0 ? (levels / maxLevels) * 100 : 0;
              return (
                <div
                  key={sid}
                  className="bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-3"
                >
                  <div className="flex items-center justify-between mb-1.5">
                    <span className="text-sm font-medium text-gray-200">{name}</span>
                    <span className="text-sm text-gray-400">
                      <span className={levels >= maxLevels ? 'text-amber-400 font-semibold' : 'text-purple-400'}>
                        {levels}
                      </span>
                      <span className="text-gray-500">/{maxLevels}</span>
                      {poolXp > 0 && (
                        <span className="text-gray-500 ml-2 text-xs">({fmt(poolXp)} pool)</span>
                      )}
                    </span>
                  </div>
                  <div className="h-2 bg-[#0d1117] rounded-full overflow-hidden">
                    <div
                      className="h-full rounded-full transition-all duration-300 bg-purple-500"
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Monsters Section */}
      <div className="mb-8">
        <h2 className="text-lg font-semibold text-gray-100 mb-4">
          Monsters
          <span className="ml-2 text-sm font-normal text-gray-500">
            {uniqueMonstersKilled}/{totalMonsters} discovered
          </span>
        </h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {monsterEntries.map(([mid, monsterDef]) => {
            const kills = monstersKilled[mid] ?? 0;
            const found = kills > 0;
            return (
              <div
                key={mid}
                className={`bg-[#111827] border rounded-lg px-4 py-3 ${
                  found ? 'border-[#1e293b]' : 'border-[#1e293b]/50 opacity-60'
                }`}
              >
                <div className="flex items-center justify-between">
                  <span className={`text-sm font-medium ${found ? 'text-gray-200' : 'text-gray-500'}`}>
                    {monsterDef.name}
                  </span>
                  <span className="text-xs text-gray-500">
                    {found ? `${fmt(kills)} kills` : 'Undiscovered'}
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Dungeons Section */}
      {totalDungeons > 0 && (
        <div className="mb-8">
          <h2 className="text-lg font-semibold text-gray-100 mb-4">
            Dungeons
            <span className="ml-2 text-sm font-normal text-gray-500">
              {uniqueDungeonsCleared}/{totalDungeons} cleared
            </span>
          </h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {dungeonEntries.map(([did, dungeonDef]) => {
              const clears = dungeonsCompleted[did] ?? 0;
              const cleared = clears > 0;
              return (
                <div
                  key={did}
                  className={`bg-[#111827] border rounded-lg px-4 py-3 ${
                    cleared ? 'border-[#1e293b]' : 'border-[#1e293b]/50 opacity-60'
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <span className={`text-sm font-medium ${cleared ? 'text-gray-200' : 'text-gray-500'}`}>
                      {dungeonDef.name}
                    </span>
                    <span className="text-xs text-gray-500">
                      {cleared ? `${fmt(clears)} clears` : 'Not cleared'}
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Pets Section */}
      {totalPets > 0 && (
        <div className="mb-8">
          <h2 className="text-lg font-semibold text-gray-100 mb-4">
            Pets
            <span className="ml-2 text-sm font-normal text-gray-500">
              {petsFoundCount}/{totalPets} found
            </span>
          </h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {petEntries.map(([pid, petDef]) => {
              const found = petsFound.includes(pid);
              return (
                <div
                  key={pid}
                  className={`bg-[#111827] border rounded-lg px-4 py-3 ${
                    found ? 'border-[#1e293b]' : 'border-[#1e293b]/50 opacity-60'
                  }`}
                >
                  <span className={`text-sm font-medium ${found ? 'text-gray-200' : 'text-gray-500'}`}>
                    {found ? petDef.name : '???'}
                  </span>
                </div>
              );
            })}
          </div>
        </div>
      )}

      {/* Statistics Section */}
      <div className="mb-8">
        <h2 className="text-lg font-semibold text-gray-100 mb-4">Statistics</h2>
        <div className="bg-[#111827] border border-[#1e293b] rounded-lg divide-y divide-[#374151]">
          {[
            { label: 'Total XP Earned', value: fmt(stats?.totalXpEarned ?? 0) },
            { label: 'Total GP Earned', value: fmt(stats?.totalGpEarned ?? 0) },
            { label: 'Total GP Spent', value: fmt(stats?.totalGpSpent ?? 0) },
            { label: 'Max Hit Dealt', value: fmt(stats?.maxHitDealt ?? 0) },
            { label: 'Total Actions', value: fmt(totalActions) },
            { label: 'Total Kills', value: fmt(totalKills) },
          ].map((row) => (
            <div key={row.label} className="flex items-center justify-between px-5 py-3">
              <span className="text-sm text-gray-400">{row.label}</span>
              <span className="text-sm font-semibold text-gray-100">{row.value}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
