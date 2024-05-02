const router = require("express").Router();
const { ResourceService } = require("../services/resource");
const { wrapResponse, STATUS_CODE } = require("../utils/http");
const { validate } = require("../utils/validate");
const { ActionType } = require("../utils/service");

const ALLOW_RESOURCE = ["videos", "documents"];

router.use(async (req, res, next) => {
    req.service = new ResourceService(req);
    next();
});

router.get("/:resourceType/:id", async (req, res) => {
    const { id, resourceType } = req.params;
    if (!ALLOW_RESOURCE.includes(resourceType)) {
        return wrapResponse(res, {
            code: STATUS_CODE.HTTP_400_BAD_REQUEST,
            message: "Invalid resource type"
        });
    }
    const resource = await req.service.fetchResource({
        id,
        type: resourceType
    });
    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_200_OK,
        message: "Video fetched successfully",
        data: resource
    });
});

router.post("/videos", validate({
    title: "isString",
    download_url: "isString",
    description: "isString",
    duration: "isNumeric",
    lessonId: "isString"
}), async (req, res) => {
    const {
        title,
        download_url,
        description,
        duration
    } = req.body;

    const resource = await req.service.createResource({
        type: "videos",
        lessonId: req.query.lessonId,
        resource: {
            title,
            download_url,
            description,
            duration
        },
        resourceId: req.query.lessonId,
        actionType: ActionType.UPDATE
    });

    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_201_CREATED,
        message: "Video created successfully",
        data: resource
    });
});

router.post("/documents", validate({
    title: "isString",
    download_url: "isString",
    material: "isString",
    author: "isString",
    format: "isString",
    type: "isString",
    lessonId: "isString"
}), async (req, res) => {
    const {
        title,
        download_url,
        material,
        author,
        format,
        type
    } = req.body;

    const resource = await req.service.createResource({
        type: "documents",
        lessonId: req.query.lessonId,
        resource: {
            title,
            download_url,
            material,
            author,
            format,
            type
        },
        resourceId: req.query.lessonId,
        actionType: ActionType.UPDATE
    });

    return wrapResponse(res, {
        code: STATUS_CODE.HTTP_201_CREATED,
        message: "Document created successfully",
        data: resource
    });
});

module.exports = router;