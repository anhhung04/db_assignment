import { memo } from "react";
import "./style.scss";
const Footer = () => {
    return <footer className="footer">
        <div className="container">
            <div className="row">
                <div className="col-lg-3">
                    <div className="footer_about">
                        <h1 className="footer_about_logo">LOGO</h1>
                        <ul>
                            <li>Liên hệ:</li>
                            <li>Email:</li>
                            <li></li>
                        </ul>
                    </div>
                </div>
                <div className="col-lg-3">2</div>
                <div className="col-lg-3">3</div>
                <div className="col-lg-3">4</div>
            </div>

        </div>
    </footer>;
}

const MemoizedFooter = memo(Footer);
export default MemoizedFooter;
