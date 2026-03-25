import type { GameState, GameDefs, SkillId, ActionId, ItemId, AreaId, MonsterId, CombatStyle, EquipmentSlot, PrayerId, DungeonId, PetId, SpellId } from './types';

let onAuthFailure = () => {
  window.location.href = '/~/login?redirect=' + encodeURIComponent(window.location.pathname);
};

export function setAuthFailureHandler(handler: () => void) {
  onAuthFailure = handler;
}

async function fetchJSON<T>(url: string): Promise<T> {
  const res = await fetch(url, { credentials: 'same-origin' });
  if (!res.ok) {
    if (res.status === 401 || res.status === 403) {
      onAuthFailure();
    }
    throw new Error(`fetch failed: ${res.status}`);
  }
  return res.json();
}

async function post(path: string): Promise<void> {
  await fetch('/apps/bide/api/' + path, {
    method: 'POST',
    credentials: 'same-origin',
  });
}

export const api = {
  getState: () => fetchJSON<GameState>('/apps/bide/api/state'),
  getDefs: () => fetchJSON<GameDefs>('/apps/bide/api/defs'),
  startAction: (skill: SkillId, action: ActionId, secondary?: ActionId | null) =>
    post(secondary ? `start/${skill}/${action}/${secondary}` : `start/${skill}/${action}`),
  stopAction: () => post('stop'),
  sell: (item: ItemId, qty: number) => post(`sell/${item}/${qty}`),
  sellAll: (item: ItemId) => post(`sell-all/${item}`),
  equip: (item: ItemId) => post(`equip/${item}`),
  unequip: (slot: EquipmentSlot) => post(`unequip/${slot}`),
  startCombat: (area: AreaId, monster: MonsterId, style: CombatStyle, spell: SpellId | null = null) =>
    post(`start-combat/${area}/${monster}/${style}/${spell ?? 'none'}`),
  stopCombat: () => post('stop-combat'),
  setAutoEat: (threshold: number, food: ItemId | null) =>
    post(`set-auto-eat/${threshold}/${food ?? 'none'}`),
  drinkPotion: (item: ItemId) => post(`drink-potion/${item}`),
  togglePrayer: (prayer: PrayerId) => post(`toggle-prayer/${prayer}`),
  buryBones: (item: ItemId) => post(`bury-bones/${item}`),
  getSlayerTask: () => post('get-slayer-task'),
  specialAttack: () => post('special-attack'),
  changeSpell: (spell: SpellId | null) => post(`change-spell/${spell ?? 'none'}`),
  startDungeon: (dungeon: DungeonId, style: CombatStyle, spell: SpellId | null = null) =>
    post(`start-dungeon/${dungeon}/${style}/${spell ?? 'none'}`),
  plantSeed: (plot: number, seed: ItemId) => post(`plant-seed/${plot}/${seed}`),
  harvestPlot: (plot: number) => post(`harvest-plot/${plot}`),
  summonFamiliar: (tablet: ItemId) => post(`summon-familiar/${tablet}`),
  dismissFamiliar: () => post('dismiss-familiar'),
  eatFood: (item: ItemId) => post(`eat-food/${item}`),
  buy: (item: ItemId, qty: number) => post(`buy/${item}/${qty}`),
  setPet: (pet: PetId | null) => post(`set-pet/${pet ?? 'none'}`),
  upgradeStar: (constellation: ActionId, idx: number) => post(`upgrade-star/${constellation}/${idx}`),
  buySkillUpgrade: (skill: SkillId, type: string) => post(`buy-skill-upgrade/${skill}/${type}`),
  buyMultitree: () => post('buy-multitree'),
};
