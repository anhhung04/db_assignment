import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import apiCall from "../../utils/api";

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
                                hide();
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
                alert(res.message);
            }
        });
    }, [setCourse, slug]);
    useEffect(() => {
        apiCall(`/api/auth/me`).then((res) => {
            if (res.status_code === 200) {
                setUser(res.data);
            } else {
                alert(res.message);
            }
        });
    }, [setUser]);
    return (
        <>
            <div>
                <h1>{course.headline}</h1>
                <img src={course.thumbnail_url} alt={course.headline} />
                <p>{course.description}</p>
                <p>{course.content_info}</p>
                <p>{course.type}</p>
                <p>{course.level}</p>
                <p>{course.amount_price}</p>
                <p>{course.currency}</p>
                <p>{course.created_at}</p>
                {user.role !== "student" ? (
                    <EditCourseBody courseId={course.id} />
                ) : null}
            </div>
        </>
    );
};

export default CourseDetailPage;
