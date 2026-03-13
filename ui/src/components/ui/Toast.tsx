import type { Toast as ToastT } from '../../hooks/useToast';

const accentColors: Record<string, string> = {
  info: '#3b82f6',
  success: '#10b981',
  warning: '#f59e0b',
  error: '#ef4444',
  levelup: '#eab308',
};

interface Props {
  toast: ToastT;
  onClose: () => void;
}

export function Toast({ toast, onClose }: Props) {
  const accent = accentColors[toast.type] || accentColors.info;

  return (
    <div
      className="flex items-center gap-3 pl-4 pr-3 py-3 bg-[#111827] border border-[#1e293b] rounded-lg text-[13px] text-gray-100 shadow-[0_8px_32px_rgba(0,0,0,0.5)] animate-[slide-up_0.3s_ease-out]"
      style={{ borderLeftColor: accent, borderLeftWidth: '3px' }}
    >
      <span className="flex-1">{toast.message}</span>
      <button
        onClick={onClose}
        className="bg-transparent border-none text-gray-600 cursor-pointer text-sm p-0 leading-none hover:text-gray-300 transition-colors"
      >
        &times;
      </button>
    </div>
  );
}
