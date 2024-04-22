import { useState, useEffect } from "react"
import LoginForm from "./pages/LoginPage/LoginPage"

export default function App() {
  const [state, setState] = useState("error")
  useEffect(() => {
    async function fetchData() {
      const data = await fetch("/api/demo").then(res => res.json())
      if (data?.data) setState(data.data.message)
    }
    fetchData()
  }, [state])
  return (
    <div>
      <LoginPage />
    </div>
  )
}