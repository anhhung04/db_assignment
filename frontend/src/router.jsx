import { Routes, Route } from "react-router-dom";
import HomePage from "./pages/homePage";
import { ROUTERS } from "./utils/router";
import MasterLayout from "./pages/theme/masterLayout";
<<<<<<< HEAD
import ProfilePage from "./pages/profilePage/users";
import LoginPage from "./pages/LoginPage";
=======
import ProfilePage from "./pages/profilePage";
import LoginPage from "./pages/LoginPage/LoginPage";
>>>>>>> 302948451a38b069d987327e25d45bed7c01eb25

const renderUserRouter = () => {
    const userRouters = [
        {
            path: ROUTERS.USER.HOME,
            component: <HomePage />,
        },
        {
            path: ROUTERS.USER.PROFILE,
            component: <ProfilePage />,
        },
        {
            path: ROUTERS.USER.LOGIN,
            component: <LoginPage />,
<<<<<<< HEAD
        },
=======
        }
>>>>>>> 302948451a38b069d987327e25d45bed7c01eb25
    ];

    return (
        <MasterLayout>
            <Routes>
                {
                    userRouters.map((item, key) => (
                        <Route key={key} path={item.path} element={item.component} />
                    ))
                }
            </Routes>
        </MasterLayout>
    );
};

const RouterCustom = () => {
    return renderUserRouter();
}

export default RouterCustom;
