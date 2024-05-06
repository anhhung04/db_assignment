import { Routes, Route } from "react-router-dom";
import HomePage from "./pages/homePage";
import { ROUTERS } from "./utils/router";
import MasterLayout from "./pages/theme/masterLayout";
import ProfilePage from "./pages/profilePage";
import LoginPage from "./pages/LoginPage";
import OwnCoursePage from "./pages/course/ownCourse";
import CourseDetailPage from "./pages/course/courseDetail";
import FilterCoursePage from "./pages/course/filterCourse";
import CreateCoursePage from "./pages/course/createCourse";

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
        },
        {
            path: ROUTERS.COURSES.MYCOURSES,
            component: <OwnCoursePage />,
        },
        {
            path: ROUTERS.COURSES.DETAIL,
            component: <CourseDetailPage />,
        },
        {
            path: ROUTERS.COURSES.FILTER,
            component: <FilterCoursePage />,
        },
        {
            path: ROUTERS.COURSES.CREATE,
            component: <CreateCoursePage />,
        },
    ];

    return (
        <MasterLayout>
            <Routes>
                {userRouters.map((item, key) => (
                    <Route
                        key={key}
                        path={item.path}
                        element={item.component}
                    />
                ))}
            </Routes>
        </MasterLayout>
    );
};

const RouterCustom = () => {
    return renderUserRouter();
}

export default RouterCustom;
