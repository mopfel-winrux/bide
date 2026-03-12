import { Link } from 'react-router-dom';

export function NotFoundPage() {
  return (
    <div className="flex flex-col items-center justify-center py-24 text-center">
      <div className="text-4xl font-bold text-gray-500 mb-3">404</div>
      <p className="text-gray-400 mb-6">Page not found</p>
      <Link to="/" className="text-amber-500 hover:text-amber-400 text-sm">
        Back to Overview
      </Link>
    </div>
  );
}
