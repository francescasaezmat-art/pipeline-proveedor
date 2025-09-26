import { useEffect, useState } from 'react'
import { supabase } from '../utils/supabase'

export default function Home() {
  const [rows, setRows] = useState<any[]>([])

  useEffect(() => {
    const fetchData = async () => {
      const { data } = await supabase.from('proveedor').select('*')
      setRows(data || [])
    }
    fetchData()
  }, [])

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-4">Proveedores</h1>
      <table className="min-w-full border">
        <thead>
          <tr className="bg-gray-100">
            <th className="border px-4 py-2">CUIT</th>
            <th className="border px-4 py-2">Razón Social</th>
            <th className="border px-4 py-2">Estado</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id}>
              <td className="border px-4 py-2">{r.cuit}</td>
              <td className="border px-4 py-2">{r.razon_social}</td>
              <td className="border px-4 py-2">{r.estado}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}