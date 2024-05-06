const CourseCard = ({ course, isHighLight }) => {
    return (
        <>
            <div>
                <img src={course.thumbnail_url} />
                <a href={`/course/${course.course_slug}`}>{course.title}</a>
                <p>{course.headline}</p>
                <p>
                    {course.amount_price} {course.currency}
                </p>
                <p>Trình độ: {course.level}</p>
                <p>Học sinh đã đăng ký: {course.total_students}</p>
                {isHighLight && (
                    <>
                        <p>
                            Lượt đăng ký trong 1 tháng qua:{" "}
                            {course.recent_students}
                        </p>
                        <p>Lượt đánh giá: {course.total_reviews}</p>
                        <p>Điểm đánh giá: {course.rating} / 5</p>
                    </>
                )}
            </div>
        </>
    );
};

export default CourseCard;
