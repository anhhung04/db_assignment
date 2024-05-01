const router = require("express").Router();
const { ResourceService } = require("../services/resource");
const { wrapResponse, STATUS_CODE } = require("../utils/http");

router.use(async (req, res, next) => {
    req.service = new ResourceService(req);
    next();
});

router.get("/video/:id", async (req, res) => {
    const { id } = req.params;
    const video = await req.service.getVideo(id);
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_200_OK,
        message: "Video fetched successfully",
        data: video
    });
});