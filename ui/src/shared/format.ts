export function fmt(n: number | undefined | null): string {
  if (n === undefined || n === null || Number.isNaN(n)) return '0';
  return Number(n).toLocaleString();
}

export function fmtGP(n: number): string {
  if (n >= 1e9) return (n / 1e9).toFixed(1) + 'B';
  if (n >= 1e6) return (n / 1e6).toFixed(1) + 'M';
  if (n >= 1e3) return (n / 1e3).toFixed(1) + 'K';
  return fmt(n);
}

export function fmtTime(ms: number): string {
  return (ms / 1000).toFixed(1) + 's';
}
