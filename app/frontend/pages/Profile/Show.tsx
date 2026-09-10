import React from 'react'
import { useForm, router, Link } from '@inertiajs/react'

interface UserProps {
  id: number
  full_name: string
  email_address: string
  role: string
  avatar_url: string
}

export default function Show({ user }: { user: UserProps }) {
  const { data, setData, post, processing } = useForm({
    _method: 'patch',
    full_name: user.full_name,
    email_address: user.email_address,
    avatar: null as File | null,
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    post('/profile')
  }

  const handleDelete = () => {
    if (confirm('Tem certeza que deseja excluir sua conta?')) {
      router.delete('/profile')
    }
  }

  return (
    <div className="max-w-4xl mx-auto p-8 space-y-8">
      <div className="flex justify-between items-center bg-white p-6 rounded-xl shadow-sm border border-gray-100">
        <div className="flex items-center space-x-4">
          <img src={user.avatar_url} alt={user.full_name} className="w-16 h-16 rounded-full object-cover" />
          <div>
            <h1 className="text-2xl font-bold text-gray-900">{user.full_name}</h1>
            <p className="text-sm text-gray-500">{user.email_address} • <span className="uppercase font-semibold text-indigo-600">{user.role}</span></p>
          </div>
        </div>
        <Link href="/logout" method="delete" as="button" className="px-4 py-2 text-sm text-red-600 border border-red-200 rounded-lg hover:bg-red-50">
          Sair
        </Link>
      </div>

      <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 space-y-6">
        <h2 className="text-xl font-semibold text-gray-800">Editar Meu Perfil</h2>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700">Nome Completo</label>
            <input
              type="text"
              value={data.full_name}
              onChange={(e) => setData('full_name', e.target.value)}
              className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm"
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700">Novo Avatar (Opcional)</label>
            <input
              type="file"
              accept="image/*"
              onChange={(e) => setData('avatar', e.target.files ? e.target.files[0] : null)}
              className="mt-1 block w-full text-sm text-gray-500"
            />
          </div>

          <div className="flex justify-between items-center pt-4">
            <button
              type="submit"
              disabled={processing}
              className="px-5 py-2.5 bg-indigo-600 text-white font-medium rounded-lg hover:bg-indigo-700 disabled:opacity-50"
            >
              Salvar Alterações
            </button>

            <button
              type="button"
              onClick={handleDelete}
              className="text-sm text-red-600 hover:text-red-800 underline"
            >
              Excluir minha conta
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}