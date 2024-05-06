import { memo } from "react";
import "./style.scss";
import { ROUTERS } from "../../../utils/router";
const Footer = () => {
    return (
        <footer className="footer">
            <div className="container">
                <div className="row">
                    <div className="col-lg-3">
                        <div className="footer_about">
                            <img
                                src="/assets/users/image/logo/logo.png"
                                alt="Dashboard"
                                className="footer_logo"
                                onClick={() => {
                                    window.location.href = ROUTERS.USER.HOME;
                                }}
                            />
                            <ul>
                                <li>Liên hệ: 00000000000</li>
                                <li>Email: example@gmail.com</li>
                                <li></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
    );
};

const MemoizedFooter = memo(Footer);
export default MemoizedFooter;
