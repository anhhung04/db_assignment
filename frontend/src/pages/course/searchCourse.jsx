import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import apiCall from "../../utils/api";
import PaginatedItems from "./pagination";

const SearchCoursePage = () => {
    const itemsPerPage = 5;
    const { searchContent } = useParams();
    const [itemOffset, setItemOffset] = useState(1);
    const [courses, setCourses] = useState([]);

    useEffect(() => {
        let page = Math.floor(itemOffset / itemsPerPage + 1);
        apiCall(
            `/api/course/search?content=${searchContent}&page=${page}&imit=${itemsPerPage}`
        ).then((res) => {
            if (res.status_code === 200) {
                setCourses(res.data);
            }
        });
    }, [searchContent, setCourses, itemOffset, itemsPerPage]);

    function handlePageClick(event) {
        const newOffset = event.selected * itemsPerPage;
        setItemOffset(newOffset);
    }

    return (
        <div>
            <h1>Kết quả tìm kiếm:</h1>
            <PaginatedItems items={courses} handlePageClick={handlePageClick} />
        </div>
    );
};

export default SearchCoursePage;
