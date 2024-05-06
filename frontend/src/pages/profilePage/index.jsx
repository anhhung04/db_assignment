import { memo } from "react";

const ProfilePage = () => {
    return <h1>ProfilePage</h1>

}

const MemoizedProfilePage = memo(ProfilePage);

export default MemoizedProfilePage;
