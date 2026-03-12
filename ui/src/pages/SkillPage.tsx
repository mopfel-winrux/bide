import { useParams } from 'react-router-dom';
import { useGame } from '../context/GameContext';
import { XpBar } from '../components/ui/XpBar';
import { XpDropContainer } from '../components/XpDrop';
import { ActiveAction } from '../components/ActiveAction';
import { ActionCard } from '../components/ActionCard';
import { EmptyState } from '../components/ui/EmptyState';
import { useState } from 'react';

type Filter = 'all' | 'unlocked' | 'locked';

export function SkillPage() {
  const { skillId } = useParams<{ skillId: string }>();
  const { defs, getDisplaySkill } = useGame();
  const [filter, setFilter] = useState<Filter>('all');

  if (!skillId || !defs?.skills[skillId]) {
    return <EmptyState>Unknown skill.</EmptyState>;
  }

  const sd = defs.skills[skillId];
  const ds = getDisplaySkill(skillId);

  const filteredActions = sd.actions.filter((act) => {
    if (filter === 'unlocked') return act.levelReq <= ds.level;
    if (filter === 'locked') return act.levelReq > ds.level;
    return true;
  });

  return (
    <div>
      <div className="flex items-baseline gap-4 mb-6">
        <h1 className="text-2xl font-bold">{sd.name}</h1>
        <div className="text-base text-gray-400">
          Level <span className="text-gray-100 font-semibold">{ds.level}</span>
        </div>
      </div>

      <XpBar xp={ds.xp} level={ds.level} className="mb-8" />
      <XpDropContainer />
      <ActiveAction />

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
                  : 'border-[#374151] bg-transparent text-gray-500 hover:text-gray-300'
              }`}
            >
              {f.charAt(0).toUpperCase() + f.slice(1)}
            </button>
          ))}
        </div>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
        {filteredActions.map((act) => (
          <ActionCard key={act.id} action={act} skillId={skillId} playerLevel={ds.level} />
        ))}
      </div>

      {filteredActions.length === 0 && (
        <EmptyState>No actions match this filter.</EmptyState>
      )}
    </div>
  );
}
