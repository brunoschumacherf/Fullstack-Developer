import React from 'react'
import { useForm, Link } from '@inertiajs/react'

export default function Login() {
  const { data, setData, post, processing } = useForm({
    email_address: '',
    password: '',
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    post('/login')
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8 bg-white p-8 rounded-xl shadow-md border border-gray-100">
        <div>
          <h2 className="text-center text-3xl font-extrabold text-gray-900">
            Acesse sua conta
          </h2>
        </div>
        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700">E-mail</label>
              <input
                type="email"
                required
                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500 text-sm"
                value={data.email_address}
                onChange={(e) => setData('email_address', e.target.value)}
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700">Senha</label>
              <input
                type="password"
                required
                className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-indigo-500 focus:border-indigo-500 text-sm"
                value={data.password}
                onChange={(e) => setData('password', e.target.value)}
              />
            </div>
          </div>

          <button
            type="submit"
            disabled={processing}
            className="w-full py-2.5 px-4 text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none disabled:opacity-50"
          >
            Entrar
          </button>
        </form>

        <div className="text-center text-sm">
          <span className="text-gray-600">Não tem uma conta? </span>
          <Link href="/register" className="font-medium text-indigo-600 hover:text-indigo-500">
            Cadastre-se
          </Link>
        </div>
      </div>
    </div>
  )
}