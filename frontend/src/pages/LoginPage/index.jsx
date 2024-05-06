import { FaUser, FaLock } from "react-icons/fa";
import "./style.scss";
import { useState } from "react";
import apiCall from "../../utils/api";

const LoginPage = () => {
    const [user, setUser] = useState({});
    return (
        <div className="wrapper">
            <form action="">
                <h1>Đăng nhập vào tài khoản của bạn</h1>
                <div className="input-box">
                    <input
                        type="text"
                        placeholder="Tên đăng nhập/Email"
                        required
                        onChange={(e) => {
                            if (e.target.value.includes("@")) {
                                setUser({
                                    ...user,
                                    email: e.target.value,
                                });
                                delete user.username;
                            } else {
                                setUser({
                                    ...user,
                                    username: e.target.value,
                                });
                                delete user.email;
                            }
                        }}
                    />
                    <FaUser className="icon" />
                </div>
                <div className="input-box">
                    <input
                        type="password"
                        placeholder="Mật khẩu"
                        required
                        onChange={(e) => {
                            setUser({
                                ...user,
                                password: e.target.value,
                            });
                        }}
                    />
                    <FaLock className="icon" />
                </div>

                <div className="remember-forgot">
                    <label>
                        <input type="checkbox" />
                        Ghi nhớ đăng nhập
                    </label>
                    <a href="#">Quên mật khẩu?</a>
                </div>
                <button
                    type="submit"
                    onClick={(e) => {
                        e.preventDefault();
                        apiCall("/api/auth/login", "POST", user).then((res) => {
                            if (res.status_code === 200) {
                                window.location.href = "/";
                            } else {
                                alert(res.message);
                            }
                        });
                    }}
                >
                    Đăng nhập
                </button>
                <div className="register-link">
                    <p>
                        Bạn vẫn chưa có tài khoản? <a href="#">Đăng ký</a>
                    </p>
                </div>
            </form>
        </div>
    );
};

export default LoginPage;
