import "./style.scss";

const CourseCard = ({ course }) => {
    return (
        <>
            <div className="course_card_list">
                <img className="course_image" src={course.thumbnail_url} />
                <div className="course_information">
                    <a href={`/course/${course.course_slug}`}>{course.title}</a>
                    <p>{course.headline}</p>

                    <div className="teacher-infor">
                        <p>Trình độ: {course.level}</p>
                        <p>Điểm đánh giá: {course.rating} / 5</p>
                        <p>Học sinh đã tham gia: {course.total_students}</p>
                        <p>Tag: {course.content_info}</p>
                    </div>
                </div>
                <div className="teacher-field">
                    <div className="ele-img">
                        <p>Giáo viên:</p>
                        <img
                            className="teacher-field-ele teacher-img"
                            src={course.teacher.avatar_url}
                            alt={course.teacher.display_name}
                        />
                        <p className="teacher-field-ele">
                            {course.teacher.display_name}
                        </p>
                    </div>

                    <p className="price">
                        {course.amount_price} {course.currency}
                    </p>
                </div>
            </div>
        </>
    );
};

export default CourseCard;
