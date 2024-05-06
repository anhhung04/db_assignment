import { FaUser, FaLock } from "react-icons/fa";
import './style.scss';

const LoginPage = () => {
    return (
        <div className='wrapper'>
            <form action="">
                <h1>Đăng nhập vào tài khoản của bạn</h1>
                <div className="input-box">
                    <input type="text" placeholder='Tên đăng nhập/Email' required />
                    <FaUser className='icon' />
                </div>
                <div className="input-box">
                    <input type="password" placeholder='Mật khẩu' required />
                    <FaLock className='icon' />
                </div>

                <div className="remember-forgot">
                    <label><input type="checkbox" />Ghi nhớ đăng nhập</label>
                    <a href="#">Quên mật khẩu?</a>
                </div>
                <button type="submit">Đăng nhập</button>
                <div className="register-link">
                    <p>Bạn vẫn chưa có tài khoản? <a href="#">Đăng ký</a></p>
                </div>
            </form>
        </div>
    )
}

export default LoginPage;