import { useState } from "react";
import "./createCourse.scss";
import apiCall from "../../utils/api";

const CreateCourse = () => {
    const [formData, setFormData] = useState({
        title: "",
        type: "",
        description: "",
        level: "",
        thumbnail_url: "",
        headline: "",
        content_info: "",
        amount_price: "",
        currency: "",
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        apiCall("/api/course", "POST", formData).then((res) => {
            if (res.status_code === 200 || res.status_code === 201) {
                window.location.href = "/my-courses";
            } else {
                alert(res.error);
            }
        });
    };

    return (
        <div className="create-course-container">
            <h2>Tạo Khóa Học Mới</h2>
            <form onSubmit={handleSubmit}>
                <div className="form-group">
                    <label>Tiêu Đề:</label>
                    <input
                        type="text"
                        name="title"
                        value={formData.title}
                        onChange={handleChange}
                    />
                </div>
                <div className="form-group">
                    <label>Loại:</label>
                    <select id="type" name="type" onChange={handleChange}>
                        <option value="free">Miễn phí</option>
                        <option value="paid">Trả phí</option>
                    </select>
                </div>
                <div className="form-group">
                    <label>Mô Tả:</label>
                    <textarea
                        name="description"
                        value={formData.description}
                        onChange={handleChange}
                    />
                </div>
                <div className="form-group">
                    <label>Trình Độ:</label>
                    <input
                        type="text"
                        name="level"
                        value={formData.level}
                        onChange={handleChange}
                    />
                </div>
                <div className="form-group">
                    <label>URL Ảnh Đại Diện:</label>
                    <input
                        type="text"
                        name="thumbnail_url"
                        value={formData.thumbnail_url}
                        onChange={handleChange}
                    />
                </div>
                <div className="form-group">
                    <label>Tiêu Đề Phụ:</label>
                    <input
                        type="text"
                        name="headline"
                        value={formData.headline}
                        onChange={handleChange}
                    />
                </div>
                <div className="form-group">
                    <label>Thông Tin Nội Dung:</label>
                    <textarea
                        name="content_info"
                        value={formData.content_info}
                        onChange={handleChange}
                    />
                </div>
                <div className="form-group">
                    <label>Giá Tiền:</label>
                    <input
                        type="number"
                        name="amount_price"
                        value={formData.amount_price}
                        onChange={handleChange}
                    />
                </div>
                <div className="form-group">
                    <label>Loại Tiền Tệ:</label>
                    <select
                        id="currency"
                        name="currency"
                        onChange={handleChange}
                    >
                        <option value="usd">USD</option>
                        <option value="eur">EUR</option>
                        <option value="vnd">VND</option>
                    </select>
                </div>
                <button type="submit">Tạo Khóa Học</button>
            </form>
        </div>
    );
};

export default CreateCourse;
