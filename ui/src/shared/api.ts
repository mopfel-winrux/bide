import type { GameState, GameDefs, SkillId, ActionId, ItemId, AreaId, MonsterId, CombatStyle, EquipmentSlot } from './types';

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
  startAction: (skill: SkillId, action: ActionId) => post(`start/${skill}/${action}`),
  stopAction: () => post('stop'),
  sell: (item: ItemId, qty: number) => post(`sell/${item}/${qty}`),
  sellAll: (item: ItemId) => post(`sell-all/${item}`),
  equip: (item: ItemId) => post(`equip/${item}`),
  unequip: (slot: EquipmentSlot) => post(`unequip/${slot}`),
  startCombat: (area: AreaId, monster: MonsterId, style: CombatStyle) =>
    post(`start-combat/${area}/${monster}/${style}`),
  stopCombat: () => post('stop-combat'),
  setAutoEat: (threshold: number, food: ItemId | null) =>
    post(`set-auto-eat/${threshold}/${food ?? 'none'}`),
};
