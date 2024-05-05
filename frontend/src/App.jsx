import RouterCustom from './router.jsx';
import { BrowserRouter } from "react-router-dom";
import "./style/style.scss";

export default function App() {
  return (
    <BrowserRouter>
      <RouterCustom />
    </BrowserRouter>
  );
}