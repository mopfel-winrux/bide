import { useGame } from '../../context/GameContext';
import { Toast } from './Toast';

export function ToastContainer() {
  const { toasts, removeToast } = useGame();

  if (toasts.length === 0) return null;

  return (
    <div className="fixed bottom-5 right-5 z-[200] flex flex-col-reverse gap-2 pointer-events-none">
      {toasts.map((t) => (
        <div key={t.id} className="pointer-events-auto">
          <Toast toast={t} onClose={() => removeToast(t.id)} />
        </div>
      ))}
    </div>
  );
}
