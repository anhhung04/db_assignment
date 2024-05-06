import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import apiCall from "../../utils/api";
import PaginatedItems from "./pagination";

const FilterCoursePage = () => {
    const itemsPerPage = 5;
    const { filterContent } = useParams();
    const [itemOffset, setItemOffset] = useState(1);
    const [courses, setCourses] = useState([]);

    useEffect(() => {
        let page = Math.floor(itemOffset / itemsPerPage + 1);
        apiCall(
            `/api/course/filter?tag=${filterContent}&page=${page}&limit=${itemsPerPage}`
        ).then((res) => {
            if (res.status_code === 200) {
                setCourses(res.data);
            }
        });
    }, [filterContent, setCourses, itemOffset, itemsPerPage]);

    function handlePageClick(event) {
        const newOffset = event.selected * itemsPerPage;
        setItemOffset(newOffset);
    }

    return (
        <div>
            <h1>Các khóa học liên quan {filterContent}:</h1>
            <PaginatedItems items={courses} handlePageClick={handlePageClick} />
        </div>
    );
};

export default FilterCoursePage;
