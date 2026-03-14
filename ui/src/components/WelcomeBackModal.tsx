import { useGame } from '../context/GameContext';
import { Button } from './ui/Button';
import { GameIcon } from './ui/GameIcon';
import { fmt, fmtGP } from '../shared/format';

function fmtElapsed(ms: number): string {
  const totalSec = Math.floor(ms / 1000);
  const d = Math.floor(totalSec / 86400);
  const h = Math.floor((totalSec % 86400) / 3600);
  const m = Math.floor((totalSec % 3600) / 60);
  const parts: string[] = [];
  if (d > 0) parts.push(`${d}d`);
  if (h > 0) parts.push(`${h}h`);
  if (m > 0) parts.push(`${m}m`);
  return parts.length > 0 ? parts.join(' ') : '<1m';
}

export function WelcomeBackModal() {
  const { welcomeBack, dismissWelcomeBack, defs } = useGame();
  if (!welcomeBack || !defs) return null;

  const { elapsedMs, gpGained, gpEarned, gpSpent, skillChanges, monstersKilled, itemChanges, dungeonsCompleted, petsFound, actionsCompleted } = welcomeBack;

  const gainedItems = itemChanges.filter((i) => i.delta > 0).slice(0, 12);
  const lostItems = itemChanges.filter((i) => i.delta < 0).slice(0, 6);

  return (
    <div className="fixed inset-0 z-[300] bg-black/60 backdrop-blur-sm flex items-center justify-center p-4" onClick={dismissWelcomeBack}>
      <div
        className="bg-[#111827] border border-[#1e293b] rounded-xl shadow-2xl max-w-md w-full max-h-[80vh] overflow-y-auto p-6"
        onClick={(e) => e.stopPropagation()}
      >
        <h2 className="text-lg font-bold text-gray-100 mb-1">While you were away...</h2>
        <p className="text-sm text-gray-500 mb-4">{fmtElapsed(elapsedMs)} offline{actionsCompleted > 0 && ` \u00b7 ${fmt(actionsCompleted)} actions`}</p>

        {/* GP */}
        {(gpEarned > 0 || gpSpent > 0) && (
          <Section title="Gold">
            <p className="text-amber-400 text-lg font-semibold">
              {gpGained >= 0 ? '+' : ''}{fmtGP(gpGained)} GP
            </p>
            {gpEarned > 0 && gpSpent > 0 && (
              <p className="text-xs text-gray-500 mt-0.5">
                {fmtGP(gpEarned)} earned &middot; {fmtGP(gpSpent)} spent
              </p>
            )}
          </Section>
        )}

        {/* Skills */}
        {skillChanges.length > 0 && (
          <Section title="Skills">
            <div className="space-y-1.5">
              {skillChanges.map((sc) => {
                const name = defs.skills[sc.skillId]?.name ?? sc.skillId;
                const leveled = sc.newLevel > sc.oldLevel;
                return (
                  <div key={sc.skillId} className="flex items-center justify-between text-sm">
                    <span className={leveled ? 'text-amber-400 font-medium' : 'text-gray-300'}>
                      {name}
                      {leveled && <span className="ml-1.5 text-xs">Lv {sc.oldLevel} → {sc.newLevel}</span>}
                    </span>
                    <span className="text-emerald-400 text-xs">+{fmt(sc.xpGained)} XP</span>
                  </div>
                );
              })}
            </div>
          </Section>
        )}

        {/* Monsters */}
        {monstersKilled.length > 0 && (
          <Section title="Monsters Killed">
            <div className="space-y-1">
              {monstersKilled.map((mk) => (
                <div key={mk.monsterId} className="flex items-center justify-between text-sm text-gray-300">
                  <span>{defs.monsters[mk.monsterId]?.name ?? mk.monsterId}</span>
                  <span className="text-gray-500">x{fmt(mk.count)}</span>
                </div>
              ))}
            </div>
          </Section>
        )}

        {/* Dungeons */}
        {dungeonsCompleted.length > 0 && (
          <Section title="Dungeons">
            <div className="space-y-1">
              {dungeonsCompleted.map((dc) => (
                <div key={dc.dungeonId} className="flex items-center justify-between text-sm text-gray-300">
                  <span>{defs.dungeons[dc.dungeonId]?.name ?? dc.dungeonId}</span>
                  <span className="text-gray-500">x{fmt(dc.count)}</span>
                </div>
              ))}
            </div>
          </Section>
        )}

        {/* Items Gained */}
        {gainedItems.length > 0 && (
          <Section title="Items Gained">
            <div className="flex flex-wrap gap-2">
              {gainedItems.map((ic) => (
                <div key={ic.itemId} className="flex items-center gap-1.5 bg-[#0d1117] rounded px-2 py-1">
                  <GameIcon category="items" id={ic.itemId} size={20} />
                  <span className="text-xs text-gray-300">{defs.items[ic.itemId]?.name ?? ic.itemId}</span>
                  <span className="text-xs text-emerald-400">+{fmt(ic.delta)}</span>
                </div>
              ))}
            </div>
          </Section>
        )}

        {/* Items Consumed */}
        {lostItems.length > 0 && (
          <Section title="Items Consumed">
            <div className="flex flex-wrap gap-2">
              {lostItems.map((ic) => (
                <div key={ic.itemId} className="flex items-center gap-1.5 bg-[#0d1117] rounded px-2 py-1">
                  <GameIcon category="items" id={ic.itemId} size={20} />
                  <span className="text-xs text-gray-300">{defs.items[ic.itemId]?.name ?? ic.itemId}</span>
                  <span className="text-xs text-red-400">{fmt(ic.delta)}</span>
                </div>
              ))}
            </div>
          </Section>
        )}

        {/* Pets */}
        {petsFound.length > 0 && (
          <Section title="New Pets!">
            <div className="space-y-1">
              {petsFound.map((pid) => (
                <p key={pid} className="text-sm text-amber-400 font-medium">{defs.pets[pid]?.name ?? pid}</p>
              ))}
            </div>
          </Section>
        )}

        <Button variant="primary" size="md" className="w-full mt-4" onClick={dismissWelcomeBack}>
          Continue
        </Button>
      </div>
    </div>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="mb-4">
      <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-1.5">{title}</h3>
      {children}
    </div>
  );
}
