import { memo, useState } from "react";
import "./style.scss";
import { CiUser } from "react-icons/ci";
import { IoIosNotifications } from "react-icons/io";
import { Link } from "react-router-dom";
import { ROUTERS } from "../../../utils/router";
import useCookie from "react-use-cookie";

const Header = () => {
    const [session] = useCookie("session");
    const isLogin = session ? true : false;
    const [menus, setFilter] = useState([
        {
            name: "Thể loại",
            isShowSubmenu: false,
            child: [
                {
                    name: "Tiếng Anh Cơ Bản",
                    path: "",
                },
                {
                    name: "Chuyên Ngành Y Khoa",
                    path: "",
                },
                {
                    name: "Giao Tiếp Nâng Cao",
                    path: "",
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
                            <li className="header_logo">
                                <h1>LOGO</h1>
                            </li>
                            <li>
                                <input
                                    type="text"
                                    placeholder="Tìm kiếm nội dung bất kỳ"
                                    required
                                />
                                <button type="submit">Tìm kiếm</button>
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
                                                                    childKey.path
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
                                <a href="/my-courses" className="my_course">
                                    Khóa học của tôi
                                </a>
                            </li>
                            <li>
                                <IoIosNotifications />
                            </li>
                            <li>
                                {isLogin ? (
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
