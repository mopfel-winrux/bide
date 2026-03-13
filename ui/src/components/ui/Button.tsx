import type { ButtonHTMLAttributes } from 'react';

type Variant = 'default' | 'primary' | 'start' | 'stop' | 'danger';
type Size = 'sm' | 'md';

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  size?: Size;
}

const variantClasses: Record<Variant, string> = {
  default: 'border-[#1e293b] bg-[#1e293b] text-gray-400 hover:bg-[#374151] hover:text-gray-100 hover:border-[#374151]',
  primary: 'border-amber-600 bg-amber-600 text-white hover:bg-amber-500 hover:border-amber-500 shadow-[0_1px_8px_rgba(217,119,6,0.15)]',
  start: 'border-amber-600 bg-amber-600 text-white hover:bg-amber-500 hover:border-amber-500 shadow-[0_1px_8px_rgba(217,119,6,0.15)] flex-1',
  stop: 'border-red-500/50 bg-transparent text-red-400 hover:bg-red-500/10 hover:border-red-500/70 flex-1',
  danger: 'border-red-500/50 bg-transparent text-red-400 hover:bg-red-500/10 hover:border-red-500/70',
};

const sizeClasses: Record<Size, string> = {
  sm: 'px-3 py-1.5 text-[12px]',
  md: 'px-4 py-2 text-sm',
};

export function Button({ variant = 'default', size = 'sm', className = '', disabled, ...props }: Props) {
  return (
    <button
      className={`inline-flex items-center justify-center gap-2 font-medium leading-none border rounded-md cursor-pointer transition-all duration-150 select-none active:scale-[0.97] disabled:opacity-35 disabled:pointer-events-none ${variantClasses[variant]} ${sizeClasses[size]} ${className}`}
      disabled={disabled}
      {...props}
    />
  );
}
