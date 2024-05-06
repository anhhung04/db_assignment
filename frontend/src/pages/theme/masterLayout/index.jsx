import { memo } from "react";
import Header from "../header/header";
import Footer from "../footer/footer";

const MasterLayout = ({ children, ...props }) => {
    return (
        <div {...props}>
            <Header />
            {children}
            <Footer />
        </div>
    )
}

const MemoizedMasterLayout = memo(MasterLayout);
export default MemoizedMasterLayout;
