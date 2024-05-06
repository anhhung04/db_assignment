import CourseCard from "../../component/course";
import { useState, useEffect } from "react";
import apiCall from "../../utils/api";
import "./allCourseStyle.scss";
import ReactPaginate from "react-paginate";

function PaginatedItems({ itemsPerPage }) {
    const [itemOffset, setItemOffset] = useState(1);
    const [courses, setCourses] = useState([]);
    useEffect(() => {
        let page = Math.floor(itemOffset / itemsPerPage + 1);
        apiCall(`/api/course?page=${page}&limit=${itemsPerPage}`).then(
            (res) => {
                setCourses(res.data);
            }
        );
    }, [setCourses, itemOffset, itemsPerPage]);
    const handlePageClick = (event) => {
        const newOffset = event.selected * itemsPerPage;
        setItemOffset(newOffset);
    };
    return (
        <>
            <div>
                {courses.map((course, key) => (
                    <CourseCard course={course} key={key} />
                ))}
            </div>
            <ReactPaginate
                breakLabel="..."
                nextLabel="next >"
                breakClassName="page-item"
                breakLinkClassName="page-link"
                onPageChange={handlePageClick}
                pageRangeDisplayed={5}
                pageCount={20}
                previousLabel="< previous"
                renderOnZeroPageCount={null}
                containerClassName="pagination justify-content-center"
                pageClassName="page-item"
                pageLinkClassName="page-link"
                previousClassName="page-item"
                previousLinkClassName="page-link"
                nextClassName="page-item"
                nextLinkClassName="page-link"
                activeClassName="active"
            />
        </>
    );
}

const AllCoursePage = () => {
    return (
        <div>
            <PaginatedItems itemsPerPage={5} />
        </div>
    );
};

export default AllCoursePage;
