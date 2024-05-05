import { memo } from "react";
import Carousel from "react-multi-carousel";
import "react-multi-carousel/lib/styles.css";
import "./style.scss"

const HomePage = () => {

    const responsive = {
        superLargeDesktop: {
            breakpoint: { max: 4000, min: 3000 },
            items: 5
        },
        desktop: {
            breakpoint: { max: 3000, min: 1024 },
            items: 3
        },
        tablet: {
            breakpoint: { max: 1024, min: 464 },
            items: 2
        },
        mobile: {
            breakpoint: { max: 464, min: 0 },
            items: 1
        }
    };

    const sliderItems = [
        {
            name: "Course",
        },
        {
            name: "Course",
        },
        {
            name: "Course",
        },
        {
            name: "Course",
        }
    ]

    return (
        <>
            {/* Categories Begin*/}
            <div className="container container__courses_slider">


                <Carousel responsive={responsive} className="courses_slider">
                    {
                        sliderItems.map((item, key) => (
                            <div className="courses_slider_item" key={key}>
                                <p>{item.name}</p>
                            </div>

                        )
                        )
                    }
                </Carousel>
            </div >


            {/*Categories End */}
        </>
    )
}

export default memo(HomePage); 
