import ReactPaginate from "react-paginate";
import CourseCard from "../../component/baseCourse";
import "./pagination.scss";

function PaginatedItems({ items, handlePageClick }) {
    return (
        <>
            <div className="list">
                {items.map((course, key) => (
                    <div className="list-item" key={key}>
                        <CourseCard course={course} />
                    </div>
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

export default PaginatedItems;
