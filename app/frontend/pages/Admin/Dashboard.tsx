import React, { useEffect, useState } from 'react'
import { useForm, router, Link } from '@inertiajs/react'

interface UserProps {
  id: number
  full_name: string
  email_address: string
  role: string
  avatar_url: string
}

interface StatsProps {
  total_users: number
  role_counts: {
    admin?: number
    member?: number
  }
}

export default function Dashboard({ stats, users }: { stats: StatsProps, users: UserProps[] }) {
  const { setData, post, processing } = useForm({ file: null as File | null })

  const handleFileUpload = (e: React.FormEvent) => {
    e.preventDefault()
    post('/admin/user_imports')
  }

  const handleRoleToggle = (userId: number, currentRole: string) => {
    const newRole = currentRole === 'admin' ? 'member' : 'admin'
    router.patch(`/admin/users/${userId}`, { user: { role: newRole } })
  }

  const handleDeleteUser = (userId: number) => {
    if (confirm('Deseja realmente remover este usuário?')) {
      router.delete(`/admin/users/${userId}`)
    }
  }

  return (
    <div className="max-w-7xl mx-auto p-8 space-y-8">
      <div className="flex justify-between items-center bg-white p-6 rounded-xl shadow-sm border border-gray-100">
        <h1 className="text-3xl font-bold text-gray-900"> Painel Administrativo</h1>
        <Link href="/logout" method="delete" as="button" className="px-4 py-2 text-sm text-red-600 border border-red-200 rounded-lg hover:bg-red-50">
          Sair
        </Link>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <p className="text-sm font-medium text-gray-500">Total de Usuários</p>
          <p className="text-4xl font-extrabold text-indigo-600 mt-2">{stats.total_users}</p>
        </div>
        <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <p className="text-sm font-medium text-gray-500">Administradores</p>
          <p className="text-4xl font-extrabold text-emerald-600 mt-2">{stats.role_counts?.admin || 0}</p>
        </div>
        <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100">
          <p className="text-sm font-medium text-gray-500">Membros</p>
          <p className="text-4xl font-extrabold text-blue-600 mt-2">{stats.role_counts?.member || 0}</p>
        </div>
      </div>

      <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 space-y-4">
        <h2 className="text-xl font-semibold text-gray-800">Importar Usuários em Lote (.CSV / .XLSX)</h2>
        <form onSubmit={handleFileUpload} className="flex items-center gap-4">
          <input
            type="file"
            accept=".csv, .xlsx"
            onChange={(e) => setData('file', e.target.files ? e.target.files[0] : null)}
            className="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100"
          />
          <button
            type="submit"
            disabled={processing}
            className="px-5 py-2.5 bg-indigo-600 text-white font-medium rounded-lg hover:bg-indigo-700 disabled:opacity-50"
          >
            Enviar
          </button>
        </form>
      </div>

      <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
        <div className="px-6 py-4 border-b border-gray-100">
          <h2 className="text-xl font-semibold text-gray-800">Lista de Usuários Cadastrados</h2>
        </div>
        <table className="w-full text-left border-collapse">
          <thead>
            <tr className="bg-gray-50 border-b border-gray-100 text-xs font-semibold text-gray-500 uppercase">
              <th className="px-6 py-3">Usuário</th>
              <th className="px-6 py-3">E-mail</th>
              <th className="px-6 py-3">Função (Role)</th>
              <th className="px-6 py-3 text-right">Ações</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100 text-sm">
            {users.map((u) => (
              <tr key={u.id} className="hover:bg-gray-50/50">
                <td className="px-6 py-4 flex items-center space-x-3">
                  <img src={u.avatar_url} alt={u.full_name} className="w-9 h-9 rounded-full object-cover" />
                  <span className="font-medium text-gray-900">{u.full_name}</span>
                </td>
                <td className="px-6 py-4 text-gray-600">{u.email_address}</td>
                <td className="px-6 py-4">
                  <span className={`px-2.5 py-1 rounded-full text-xs font-semibold ${u.role === 'admin' ? 'bg-emerald-50 text-emerald-700' : 'bg-blue-50 text-blue-700'}`}>
                    {u.role}
                  </span>
                </td>
                <td className="px-6 py-4 text-right space-x-2">
                  <button
                    onClick={() => handleRoleToggle(u.id, u.role)}
                    className="px-3 py-1.5 text-xs text-indigo-600 border border-indigo-200 rounded-md hover:bg-indigo-50"
                  >
                    Alternar Role
                  </button>
                  <button
                    onClick={() => handleDeleteUser(u.id)}
                    className="px-3 py-1.5 text-xs text-red-600 border border-red-200 rounded-md hover:bg-red-50"
                  >
                    Excluir
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}