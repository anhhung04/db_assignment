import { useState, useEffect } from "react"

export default function App() {
  const [state, setState] = useState("error")
  useEffect(() => {
    async function fetchData(){
      const data = await fetch("/api/demo").then(res => res.json())
      if(data?.message) setState(data.message)
    }
    fetchData()
  }, [state])
  return (
    <>
      <h1>{state}</h1>
    </>
  )
}