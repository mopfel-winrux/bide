import type { Toast as ToastT } from '../../hooks/useToast';

const borderColors: Record<string, string> = {
  info: 'border-l-blue-500',
  success: 'border-l-green-500',
  warning: 'border-l-amber-600',
  error: 'border-l-red-500',
  levelup: 'border-l-yellow-500',
};

interface Props {
  toast: ToastT;
  onClose: () => void;
}

export function Toast({ toast, onClose }: Props) {
  return (
    <div
      className={`flex items-center gap-3 px-5 py-3 bg-[#111827] border border-[#374151] border-l-[3px] rounded-md text-sm text-gray-100 shadow-[0_4px_20px_rgba(0,0,0,0.4)] max-w-[340px] animate-[slide-in_0.3s_ease-out] ${borderColors[toast.type] || ''} ${toast.type === 'levelup' ? 'bg-gradient-to-br from-[#111827] to-[#1a1507]' : ''}`}
    >
      <span className="flex-1">{toast.message}</span>
      <button
        onClick={onClose}
        className="bg-transparent border-none text-gray-500 cursor-pointer text-base p-0 leading-none hover:text-gray-100"
      >
        &times;
      </button>
    </div>
  );
}
