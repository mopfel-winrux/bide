import { useParams, Navigate } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { XpBar } from '../components/ui/XpBar';
import { ActiveAction } from '../components/ActiveAction';
import { ActionCard } from '../components/ActionCard';
import { SkillBonuses } from '../components/SkillBonuses';
import { EmptyState } from '../components/ui/EmptyState';
import { useState, useMemo } from 'react';
import { fmt } from '../shared/format';
import { levelFromXp } from '../shared/xp';
import { SKILL_GROUPS } from '../shared/skill-groups';
import type { ActionDef } from '../shared/types';

type Filter = 'all' | 'unlocked' | 'locked';

export function SkillPage() {
  const { skillId } = useParams<{ skillId: string }>();
  const { defs, state, getDisplaySkill } = useGame();
  const [filter, setFilter] = useState<Filter>('all');
  const [activeTab, setActiveTab] = useState<string | null>(null);

  if (skillId === 'farming') return <Navigate to="/farming" replace />;

  if (!skillId || !defs?.skills[skillId]) {
    return <EmptyState>Unknown skill.</EmptyState>;
  }

  const sd = defs.skills[skillId];
  const ds = getDisplaySkill(skillId);

  const filterAction = (act: ActionDef) => {
    if (filter === 'unlocked') return act.levelReq <= ds.level;
    if (filter === 'locked') return act.levelReq > ds.level;
    return true;
  };

  const groups = SKILL_GROUPS[skillId];
  const actionMap = useMemo(() => {
    const m = new Map<string, ActionDef>();
    for (const a of sd.actions) m.set(a.id, a);
    return m;
  }, [sd.actions]);

  // Build grouped sections or flat list
  const groupedSections = useMemo(() => {
    if (!groups) return null;
    const usedIds = new Set<string>();
    const sections: { label: string; actions: ActionDef[] }[] = [];
    for (const g of groups) {
      const acts = g.actionIds
        .map(id => actionMap.get(id))
        .filter((a): a is ActionDef => !!a && filterAction(a));
      for (const id of g.actionIds) usedIds.add(id);
      if (acts.length > 0) sections.push({ label: g.label, actions: acts });
    }
    // "Other" section for ungrouped actions
    const other = sd.actions.filter(a => !usedIds.has(a.id) && filterAction(a));
    if (other.length > 0) sections.push({ label: 'Other', actions: other });
    return sections;
  }, [groups, actionMap, sd.actions, filter, ds.level]);

  const flatFiltered = groups ? null : sd.actions.filter(filterAction);

  return (
    <div>
      <div className="flex items-baseline gap-4 mb-6">
        <h1 className="text-2xl font-bold">{sd.name}</h1>
        <div className="text-base text-gray-400">
          Level <span className="text-gray-100 font-semibold">{ds.level}</span>
        </div>
      </div>

      <XpBar xp={ds.xp} level={ds.level} className="mb-4" />

      {sd.actions.some(a => a.masteryXp > 0) && (() => {
        const ss = state?.skills[skillId];
        const poolXp = ss?.poolXp ?? 0;
        const masteryActions = ss?.masteryActions ?? {};
        const totalMasteryLevels = sd.actions.reduce((sum, a) => {
          return sum + levelFromXp(masteryActions[a.id] ?? 0);
        }, 0);
        const maxMasteryLevels = sd.actions.length * 99;
        return (
          <div className="flex items-center gap-6 text-sm text-gray-400 mb-6 bg-[#111827] border border-[#1e293b] rounded-lg px-4 py-2.5">
            <div>
              <span className="text-gray-500">Mastery Pool: </span>
              <span className="text-purple-400 font-medium">{fmt(poolXp)} XP</span>
            </div>
            <div>
              <span className="text-gray-500">Total Mastery: </span>
              <span className="text-purple-400 font-medium">{totalMasteryLevels} / {maxMasteryLevels}</span>
            </div>
          </div>
        );
      })()}

      <ActiveAction />
      <SkillBonuses skillId={skillId} />

      <div className="flex items-center justify-between mb-5">
        <h2 className="text-lg font-semibold">Actions</h2>
        <div className="flex gap-2">
          {(['all', 'unlocked', 'locked'] as Filter[]).map((f) => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={`px-3 py-1.5 text-xs rounded-md border transition-all duration-150 cursor-pointer ${
                filter === f
                  ? 'border-amber-600 bg-amber-600/10 text-amber-500'
                  : 'border-[#1e293b] bg-transparent text-gray-500 hover:text-gray-300'
              }`}
            >
              {f.charAt(0).toUpperCase() + f.slice(1)}
            </button>
          ))}
        </div>
      </div>

      {groupedSections ? (() => {
        const currentTab = activeTab ?? groupedSections[0]?.label ?? null;
        const currentSection = groupedSections.find(s => s.label === currentTab);
        return groupedSections.length === 0 ? (
          <EmptyState>No actions match this filter.</EmptyState>
        ) : (
          <div>
            <div className="flex flex-wrap gap-1 mb-5">
              {groupedSections.map(({ label }) => (
                <button
                  key={label}
                  onClick={() => setActiveTab(label)}
                  className={`px-3 py-1.5 text-xs rounded-md border transition-all duration-150 cursor-pointer ${
                    currentTab === label
                      ? 'border-amber-600 bg-amber-600/10 text-amber-500'
                      : 'border-[#1e293b] bg-transparent text-gray-500 hover:text-gray-300'
                  }`}
                >
                  {label}
                </button>
              ))}
            </div>
            {currentSection && (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                {currentSection.actions.map((act) => (
                  <ActionCard key={act.id} action={act} skillId={skillId} playerLevel={ds.level} />
                ))}
              </div>
            )}
          </div>
        );
      })() : (
        <>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            {flatFiltered!.map((act) => (
              <ActionCard key={act.id} action={act} skillId={skillId} playerLevel={ds.level} />
            ))}
          </div>
          {flatFiltered!.length === 0 && (
            <EmptyState>No actions match this filter.</EmptyState>
          )}
        </>
      )}
    </div>
  );
}
