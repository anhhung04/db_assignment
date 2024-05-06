import CourseCard from "../../component/course";
import { useState, useEffect } from "react";

const AllCoursePage = () => {
    const [courses, setCourses] = useState([]);
    useEffect(() => {
        fetch("/api/course")
            .then((res) => res.json())
            .then((data) => {
                setCourses(data);
            });
    }, [setCourses]);
    return (
        <>
            <div>
                {courses.map((course, key) => (
                    <CourseCard course={course} key={key} />
                ))}
            </div>
        </>
    );
};

export default AllCoursePage;
