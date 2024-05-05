import { memo } from "react";
import "./style.scss";
import { CiUser } from "react-icons/ci";
import { FaMagnifyingGlass } from "react-icons/fa6";
import { IoIosNotifications } from "react-icons/io";


const Header = () => {
    return (
        <div className="header_top">
            <div className="container">
                <div className="row">
                    <div className="col-6 header_top_left">
                        <ul>
                            <li className="header_logo">
                                <h1>LOGO</h1>
                            </li>
                            <li>Thể loại</li>
                            <li>
                                <FaMagnifyingGlass />
                                <input type="text" placeholder='Tìm kiếm nội dung bất kỳ' required />
                            </li>
                        </ul>
                    </div>
                    <div className="col-6 header_top_right">
                        <ul>
                            <li>
                                <a href="#">Khóa học của tôi</a>
                            </li>
                            <li>
                                <IoIosNotifications />
                            </li>
                            <li>
                                <span><button type="submit">Đăng nhập</button></span>
                                <CiUser />
                            </li>

                        </ul>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default memo(Header);    
