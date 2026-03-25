import type { ModifierSet } from './types';

export function getXpBonusPct(mods: ModifierSet | undefined, skillId: string, skillType: string | undefined): number {
  let pct = Number(mods?.xpGlobal) || 0;
  if (skillType === 'gathering') pct += Number(mods?.xpGathering) || 0;
  if (skillType === 'artisan') pct += Number(mods?.xpArtisan) || 0;
  if (skillType === 'combat') pct += Number(mods?.xpCombat) || 0;
  pct += Number(mods?.xpPerSkill?.[skillId]) || 0;
  return pct;
}

export function getSpeedBonusPct(mods: ModifierSet | undefined): number {
  return Number(mods?.speedBonus) || 0;
}

export function applyXpBonus(baseXp: number, pct: number): number {
  return baseXp + Math.floor(baseXp * pct / 100);
}

export function applySpeedBonus(baseTime: number, pct: number): number {
  return pct > 0 ? Math.max(500, baseTime - Math.floor(baseTime * pct / 100)) : baseTime;
}
