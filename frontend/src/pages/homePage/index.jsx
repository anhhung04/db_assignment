import { memo, useEffect, useState } from "react";
import Carousel from "react-multi-carousel";
import CourseCardHighlight from "../../component/highlightCourse";
import apiCall from "../../utils/api";
import AllCoursePage from "../course/allCourse";
import "react-multi-carousel/lib/styles.css";
import "./style.scss";

const HomePage = () => {
    const [sliderItems, setSliderItems] = useState([]);

    const responsive = {
        superLargeDesktop: {
            breakpoint: { max: 4000, min: 3000 },
            items: 5,
        },
        desktop: {
            breakpoint: { max: 3000, min: 1024 },
            items: 3,
        },
        tablet: {
            breakpoint: { max: 1024, min: 464 },
            items: 2,
        },
        mobile: {
            breakpoint: { max: 464, min: 0 },
            items: 1,
        },
    };

    useEffect(() => {
        apiCall("/api/course/highlight?limit=5")
            .then((res) => {
                setSliderItems(res.data);
            })
            .catch((err) => {
                console.log(err);
            });
    }, [setSliderItems]);

    return (
        <>
            {/* Categories Begin*/}
            <div>
                <h1>Khóa học nổi bật</h1>
            </div>
            <div className="container container__courses_slider">
                <Carousel responsive={responsive} className="courses_slider">
                    {sliderItems.map((item, key) => (
                        <div className="courses_slider_item" key={key}>
                            <CourseCardHighlight course={item} />
                        </div>
                    ))}
                </Carousel>
            </div>
            {/*Categories End */}

            <div>
                <h1>Khóa học hiện có</h1>
            </div>
            <AllCoursePage />
        </>
    );
};

const MemoizedHomePage = memo(HomePage);

export default MemoizedHomePage;
