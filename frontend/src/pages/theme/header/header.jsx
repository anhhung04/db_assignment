import { memo, useState, useEffect } from "react";
import "./style.scss";
import { CiUser } from "react-icons/ci";
import { IoIosNotifications } from "react-icons/io";
import { Link } from "react-router-dom";
import { ROUTERS } from "../../../utils/router";
import apiCall from "../../../utils/api";

const Header = () => {
    const [user, setUser] = useState({});
    useEffect(() => {
        apiCall("/api/auth/me").then((res) => {
            if (res.status_code === 200) {
                setUser(res.data);
            }
        });
    }, [setUser]);
    const isLogin = user.id ? true : false;
    const [menus] = useState([
        {
            name: "Thể loại",
            isShowSubmenu: false,
            child: [
                {
                    name: "TOEIC",
                    path: "/course/filter/toeic",
                },
                {
                    name: "IELTS",
                    path: "/course/filter/ielts",
                },
                {
                    name: "Communication",
                    path: "/course/filter/communication",
                },
                {
                    name: "Beginner",
                    path: "/course/filter/beginner",
                },
                {
                    name: "Intermediate",
                    path: "/course/filter/intermediate",
                },
                {
                    name: "Advance",
                    path: "/course/filter/advance",
                },
            ],
        },
    ]);

    return (
        <div className="header_top">
            <div className="container">
                <div className="row">
                    <div className="col-6 header_top_left">
                        <ul>
                            <li>
                                <img
                                    src="/assets/users/image/logo/logo.png"
                                    alt="Dashboard"
                                    className="header_logo"
                                    onClick={() => {
                                        window.location.href =
                                            ROUTERS.USER.HOME;
                                    }}
                                />
                            </li>
                            <li>
                                <input
                                    id="searchInput"
                                    type="text"
                                    placeholder="Tìm kiếm nội dung bất kỳ"
                                    required
                                />
                            </li>
                            <li>
                                <button
                                    type="submit"
                                    onClick={(e) => {
                                        e.preventDefault();
                                        window.location.href =
                                            "/course/search/" +
                                            btoa(
                                                document.getElementById(
                                                    "searchInput"
                                                ).value
                                            );
                                    }}
                                >
                                    Tìm kiếm
                                </button>
                            </li>
                        </ul>
                        <nav className="header_filter">
                            <ul>
                                {menus?.map((menu, menuKey) => (
                                    <li
                                        key={menuKey}
                                        className={
                                            menuKey === 0 ? "active" : ""
                                        }
                                    >
                                        <Link to={menu?.path}>
                                            {menu?.name}
                                        </Link>
                                        {menu.child && (
                                            <ul className="header_filter_dropform">
                                                {menu.child.map(
                                                    (childItem, childKey) => (
                                                        <li
                                                            key={`${menuKey}-${childKey}`}
                                                        >
                                                            <Link
                                                                to={
                                                                    childItem.path
                                                                }
                                                            >
                                                                {childItem.name}
                                                            </Link>
                                                        </li>
                                                    )
                                                )}
                                            </ul>
                                        )}
                                    </li>
                                ))}
                            </ul>
                        </nav>
                    </div>
                    <div className="col-6 header_top_right">
                        <ul>
                            <li>
                                {isLogin && user.role === "teacher" && (
                                    <a
                                        href="/create-course"
                                        className="my_course"
                                    >
                                        Tạo mới
                                    </a>
                                )}
                            </li>
                            <li>
                                <a href="/my-courses" className="my_course">
                                    Khóa học của tôi
                                </a>
                            </li>
                            <li>
                                <IoIosNotifications />
                            </li>
                            <li>
                                {!isLogin ? (
                                    <>
                                        <span>
                                            <button
                                                type="submit"
                                                className="login_summit"
                                                onClick={() => {
                                                    window.location.href =
                                                        ROUTERS.USER.LOGIN;
                                                }}
                                            >
                                                Đăng nhập
                                            </button>
                                        </span>
                                    </>
                                ) : null}
                                <CiUser />
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    );
};

const MemoizedHeader = memo(Header);
export default MemoizedHeader;
