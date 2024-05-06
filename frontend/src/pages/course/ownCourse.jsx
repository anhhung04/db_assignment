import CourseCard from "../../component/baseCourse";
import { useState, useEffect } from "react";
import apiCall from "../../utils/api";
import "./ownCourse.scss";

const OwnCoursePage = () => {
    const [courses, setCourses] = useState([]);
    const [user, setUser] = useState({});
    useEffect(() => {
        apiCall("/api/course/mine").then((res) => {
            if (res.status_code === 200) {
                setCourses(res.data);
            } else {
                alert(res.error);
            }
        });
    }, [setCourses]);
    useEffect(() => {
        apiCall("/api/auth/me").then((res) => {
            if (res.status_code === 200) {
                setUser(res.data);
            }
        });
    }, [setUser]);
    return (
        <>
            <div className="ownCourse">
                {courses.map((course, key) => (
                    <div key={key} className="ele-course">
                        <CourseCard course={course} />
                        {user && user.id === course.teacher_id && (
                            <button
                                className="btn-delete"
                                onClick={() => {
                                    apiCall(
                                        `/api/course/${course.course_id}`,
                                        "DELETE"
                                    ).then((res) => {
                                        if (res.status_code === 200) {
                                            window.location.reload();
                                        } else {
                                            alert(res.error);
                                        }
                                    });
                                }}
                            >
                                Delete
                            </button>
                        )}
                    </div>
                ))}
            </div>
        </>
    );
};

export default OwnCoursePage;
