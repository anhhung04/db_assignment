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
            <div>
                {editFields.map((field, key) => (
                    <div key={key}>
                        <label>{field}</label>
                        <input
                            onChange={(e) => {
                                setPatchObj({
                                    ...patchObj,
                                    [field]: e.target.value,
                                });
                            }}
                        />
                    </div>
                ))}
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
                <label>Currency</label>
                <section
                    id="currency"
                    onChange={(e) => {
                        setPatchObj({ ...patchObj, currency: e.target.value });
                    }}
                >
                    <option value="usd">USD</option>
                    <option value="eur">EUR</option>
                    <option value="vnd">VND</option>
                </section>
                <button
                    onClick={() => {
                        apiCall(`/api/course/${courseId}`, {
                            method: "PATCH",
                            body: JSON.stringify(patchObj),
                        }).then((res) => {
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
                    <p>
                        {course.amount_price} {course.currency}
                    </p>
                    <button
                        className="btn btn-primary"
                        onClick={() => {
                            apiCall(`/api/course/${course.id}/join`).then(
                                (res) => {
                                    if (res.status_code === 200) {
                                        alert("Đăng ký thành công");
                                    } else {
                                        alert(res.message);
                                    }
                                }
                            );
                        }}
                    >
                        Đăng ký
                    </button>
                </div>
            </div>
            <div>
                <h3>Mô tả khóa học</h3>
                <p>{course.description}</p>
            </div>

            <div>
                <h3>Nội dung khóa học</h3>
                {course.lessons && course.lessons.length > 0 && (
                    <>
                        <div>
                            {course.lessons.map((lesson, key) => (
                                <div key={key}>
                                    <h5>{lesson.title}</h5>
                                    <p>{lesson.description}</p>
                                </div>
                            ))}
                        </div>
                    </>
                )}
            </div>
            <div>
                {user && user.role && user.role !== "student" && (
                    <EditCourseBody courseId={course.id} />
                )}
            </div>
        </>
    );
};

export default CourseDetailPage;
