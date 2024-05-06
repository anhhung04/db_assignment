import { memo, useEffect, useState } from "react";
import Carousel from "react-multi-carousel";
import CourseCard from "../../component/course";
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
        apiCall("/api/course/highlight")
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
            <div>Khóa học nổi bật</div>

            <div className="container container__courses_slider">
                <Carousel responsive={responsive} className="courses_slider">
                    {sliderItems.map((item, key) => (
                        <div className="courses_slider_item" key={key}>
                            <CourseCard course={item} />
                        </div>
                    ))}
                </Carousel>
            </div>

            {/*Categories End */}

            <div>Tất cả khóa học</div>
            <AllCoursePage />
        </>
    );
};

const MemoizedHomePage = memo(HomePage);

export default MemoizedHomePage;
