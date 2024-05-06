const CourseCard = ({ course }) => {
    return (
        <>
            <div>
                <img src={course.thumbnail_url} />
                <a href={`/course/${course.course_slug}`}>{course.title}</a>
                <p>{course.price_amount}</p>
                <p>{course.currency}</p>
                Rating: {course.rating}
            </div>
        </>
    );
};

export default CourseCard;
