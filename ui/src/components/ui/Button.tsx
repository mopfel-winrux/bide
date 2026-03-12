import type { ButtonHTMLAttributes } from 'react';

type Variant = 'default' | 'primary' | 'start' | 'stop' | 'danger';
type Size = 'sm' | 'md';

interface Props extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  size?: Size;
}

const variantClasses: Record<Variant, string> = {
  default: 'border-[#374151] bg-[#1f2937] text-gray-400 hover:bg-[#374151] hover:text-gray-100 hover:border-gray-500',
  primary: 'border-amber-600 bg-amber-600 text-white hover:bg-amber-700 hover:border-amber-700 hover:shadow-[0_0_12px_rgba(217,119,6,0.25)]',
  start: 'border-amber-600 bg-amber-600 text-white hover:bg-amber-700 hover:border-amber-700 hover:shadow-[0_0_12px_rgba(217,119,6,0.25)] flex-1',
  stop: 'border-red-500 bg-transparent text-red-500 hover:bg-red-500 hover:text-white flex-1',
  danger: 'border-red-500 bg-transparent text-red-500 hover:bg-red-500 hover:text-white',
};

const sizeClasses: Record<Size, string> = {
  sm: 'px-3 py-1.5 text-xs',
  md: 'px-4 py-2 text-sm',
};

export function Button({ variant = 'default', size = 'sm', className = '', disabled, ...props }: Props) {
  return (
    <button
      className={`inline-flex items-center justify-center gap-2 font-medium leading-none border rounded-md cursor-pointer transition-all duration-150 select-none active:scale-[0.97] disabled:opacity-40 disabled:pointer-events-none ${variantClasses[variant]} ${sizeClasses[size]} ${className}`}
      disabled={disabled}
      {...props}
    />
  );
}
