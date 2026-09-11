type StatCardProps = { label: string; value: number; accent: string }

export default function StatCard({ label, value, accent }: StatCardProps) {
  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
      <p className="text-sm font-medium text-slate-500">{label}</p>
      <p className={`mt-2 text-4xl font-extrabold ${accent}`}>{value}</p>
    </div>
  )
}
