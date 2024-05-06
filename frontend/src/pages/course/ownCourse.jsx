import CourseCard from "../../component/highlightCourse";
import { useState, useEffect } from "react";
import apiCall from "../../utils/api";

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
            <div>
                {courses.map((course, key) => (
                    <div key={key}>
                        <CourseCard course={course} />
                        <button
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
