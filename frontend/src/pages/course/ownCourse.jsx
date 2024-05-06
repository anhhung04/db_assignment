import CourseCard from "../../component/baseCourse";
import { useState, useEffect } from "react";
import apiCall from "../../utils/api";
import "./ownCourse.scss";

const OwnCoursePage = () => {
    const [courses, setCourses] = useState([]);
    useEffect(() => {
        apiCall("/api/course/mine").then((res) => {
            if (res.status_code === 200) {
                setCourses(res.data);
            } else {
                alert(res.error);
            }
        });
    }, [setCourses]);
    return (
        <>
            <div className="ownCourse">
                {courses.map((course, key) => (
                    <div key={key} className="ele-course">
                        <CourseCard course={course} />
                        <button
                            className="btn-delete"
                            onClick={() => {
                                apiCall(`/api/course/${course.course_id}`, {
                                    method: "DELETE",
                                }).then((res) => {
                                    if (res.status_code === 200) {
                                        window.location.reload();
                                    } else {
                                        alert(res.message);
                                    }
                                });
                            }}
                        >
                            Delete
                        </button>
                    </div>
                ))}
            </div>
        </>
    );
};

export default OwnCoursePage;
