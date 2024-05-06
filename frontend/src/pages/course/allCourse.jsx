import { useState, useEffect } from "react";
import apiCall from "../../utils/api";
import PaginatedItems from "./pagination";

const AllCoursePage = () => {
    const itemsPerPage = 5;
    const [itemOffset, setItemOffset] = useState(1);
    const [courses, setCourses] = useState([]);
    useEffect(() => {
        let page = Math.floor(itemOffset / itemsPerPage + 1);
        apiCall(`/api/course?page=${page}&limit=${itemsPerPage}`).then(
            (res) => {
                if (res.status_code === 200) {
                    setCourses(res.data);
                }
            }
        );
    }, [setCourses, itemOffset, itemsPerPage]);
    const handlePageClick = (event) => {
        const newOffset = event.selected * itemsPerPage;
        setItemOffset(newOffset);
    };
    return (
        <div>
            <PaginatedItems items={courses} handlePageClick={handlePageClick} />
        </div>
    );
};

export default AllCoursePage;
