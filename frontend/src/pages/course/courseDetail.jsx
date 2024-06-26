import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import apiCall from "../../utils/api";
import "./courseDetailstyle.scss";

const EditCourseBody = ({ courseId }) => {
    const [patchObj, setPatchObj] = useState({});
    const editFields = [
        "description",
        "type",
        "level",
        "thumbnail_url",
        "headline",
        "content_info",
    ];
    return (
        <>
            <div className="form-container">
                <h2>Chỉnh sửa khóa học</h2>
                {editFields.map((field, key) => (
                    <div className="form-field" key={key}>
                        <label>{field}</label>
                        <input
                            type="text"
                            onChange={(e) => {
                                setPatchObj({
                                    ...patchObj,
                                    [field]: e.target.value,
                                });
                            }}
                        />
                    </div>
                ))}
                <div className="form-field">
                    <label>Price</label>
                    <input
                        type="number"
                        onChange={(e) => {
                            setPatchObj({
                                ...patchObj,
                                amount_price: e.target.value,
                            });
                        }}
                    />
                </div>
                <div className="form-field">
                    <label>Currency</label>
                    <select
                        id="currency"
                        onChange={(e) => {
                            setPatchObj({
                                ...patchObj,
                                currency: e.target.value,
                            });
                        }}
                    >
                        <option value="usd">USD</option>
                        <option value="eur">EUR</option>
                        <option value="vnd">VND</option>
                    </select>
                </div>
                <button
                    onClick={() => {
                        apiCall(
                            `/api/course/${courseId}`,
                            "PATCH",
                            patchObj
                        ).then((res) => {
                            if (res.status_code === 200) {
                                window.location.reload();
                            } else {
                                alert(res.message);
                            }
                        });
                    }}
                >
                    Save
                </button>
            </div>
        </>
    );
};

const CourseDetailPage = () => {
    let { slug } = useParams();
    const [course, setCourse] = useState({});
    const [user, setUser] = useState({});
    useEffect(() => {
        apiCall(`/api/course/${slug}`).then((res) => {
            if (res.status_code === 200) {
                setCourse(res.data);
            } else {
                alert(res.error);
            }
        });
    }, [setCourse, slug]);
    useEffect(() => {
        apiCall(`/api/auth/me`).then((res) => {
            if (res.status_code === 200) {
                setUser(res.data);
            }
        });
    }, [setUser]);
    return (
        <>
            <div className="general-setting">
                <div className="infor">
                    <h1>{course.title}</h1>
                    <h3>{course.headline}</h3>
                    <p>Đánh giá: {course.rating}/5</p>
                    <p>Số lượng học viên đã đăng ký: {course.total_students}</p>
                    <p>Tag: {course.content_info}</p>
                    <p>Level: {course.level}</p>

                    {course.teacher && (
                        <>
                            <div className="teacher_field">
                                <p>Giáo viên:</p>
                                <p className="teacher_name">
                                    {course.teacher.lname}{" "}
                                    {course.teacher.fname}
                                </p>
                                <img
                                    className="teacher_img"
                                    src={course.teacher.avatar_url}
                                    alt={course.teacher.display_name}
                                />
                            </div>
                        </>
                    )}
                </div>
                <div className="title-price">
                    <img
                        className="course_img"
                        src={course.thumbnail_url}
                        alt={course.title}
                    />
                    <div className="price">
                        {course.end_price ? (
                            <>
                                <p className="price-sale">
                                    {course.end_price} usd
                                </p>
                                <p className="price-notsale">
                                    {course.amount_price} {course.currency}
                                </p>
                            </>
                        ) : (
                            <>
                                <p>
                                    {course.amount_price} {course.currency}
                                </p>
                            </>
                        )}
                    </div>

                    <button
                        className="btn btn-primary"
                        onClick={() => {
                            apiCall(
                                `/api/course/${course.course_id}/join`
                            ).then((res) => {
                                if (res.status_code === 200) {
                                    window.location.href = "/my-courses";
                                } else {
                                    alert(res.error);
                                }
                            });
                        }}
                    >
                        Mua ngay
                    </button>
                </div>
            </div>
            <div className="course-container">
                <div className="course-content">
                    <h3>Mô tả khóa học</h3>
                    <p>{course.description}</p>
                </div>

                <div className="course-section">
                    <h3>Nội dung khóa học</h3>
                    {course.lessons && course.lessons.length > 0 && (
                        <div className="lesson-title">
                            {course.lessons.map((lesson, key) => (
                                <div key={key}>
                                    <h5>{lesson.title}</h5>
                                    <p>{lesson.description}</p>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
                <div className="review-container">
                    {course.reviews && course.reviews.length > 0 && (
                        <div className="review-field">
                            {course.reviews.map((review, key) => (
                                <div className="course-review" key={key}>
                                    <h3>Bình luận và nhận xét</h3>
                                    <div className="comment-user">
                                        <img
                                            className="user-avatar"
                                            src={review.student.avatar_url}
                                            alt={review.student.display_name}
                                        />
                                        <p>{review.student.display_name}</p>
                                    </div>
                                    <div className="comment-content">
                                        <div>
                                            <p>{review.comment}</p>
                                        </div>
                                        <div>
                                            <p>
                                                Đánh giá: {review.student_rate}
                                                /5
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            </div>
            <div className="edit-course">
                {user && user.role && user.role !== "student" && (
                    <EditCourseBody courseId={course.course_id} />
                )}
            </div>
        </>
    );
};

export default CourseDetailPage;
