import "./course.scss";

const CourseCard = ({ course }) => {
    return (
        <>
            <div className="course_card">
                <img
                    className="highlight_img"
                    src={course.thumbnail_url}
                    alt={course.title}
                />
                <br />
                <div className="highlight_information">
                    <a href={`/course/${course.course_slug}`}>{course.title}</a>
                    <p>Điểm đánh giá: {course.rating} / 5</p>
                    <p className="course_price">
                        {course.amount_price} {course.currency}
                    </p>
                    <div className="teacher-field">
                        <p className="">Giáo viên:</p>
                        <img
                            className="teacher-field-ele teacher-img"
                            src={course.teacher.avatar_url}
                            alt={course.teacher.display_name}
                        />
                        <p className="teacher-field-ele">
                            {course.teacher.display_name}
                        </p>
                    </div>
                    <p>Học sinh đã đăng ký: {course.total_students}</p>
                </div>
            </div>
        </>
    );
};

export default CourseCard;
