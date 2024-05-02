const router = require("express").Router();
const { ResourceService } = require("../services/resource");
const { wrapResponse, STATUS_CODE } = require("../utils/http");

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