const { IRepo } = require("./index");
const logger = require("../utils/log");
const { UUID } = require("../typedef/validator"); //eslint-disable-line no-unused-vars


class ActivityRepo extends IRepo {
    /**
     * Initialize activity repository
     */
    constructor() {
        super();
    }
    /**
     * 
     * @param {UUID} param0.activistId
     * @param {String} param0.action
     * @param {UUID} param0.resourceId
     * @param {String} param0.note
     * @returns {Promise<{activity: import("../typedef/activity").Activity, error: Error}>}
     */
    async create({ activistId, action, resourceId, note = "" }) {
        try {
            let results = await this.exec({
                query: `
                INSERT INTO activities (activist_id, resource_id, action, note)
                VALUES ($1, $2, $3, $4)
                RETURNING *
                `,
                args: [activistId, resourceId, action, note]
            });
            if (results.rowCount !== 1) {
                throw new Error("Insert activity error");
            }
            return {
                activity: results.rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                activity: null,
                error: err
            };
        }
    }
}

module.exports = {
    ActivityRepo,
    ACTION: Object.freeze({
        READ: 'read',
        CREATE: 'create',
        UPDATE: 'update',
        DELETE: 'delete',
    }),
    STATUS: Object.freeze({
        SUCCESS: 'success',
        FAILED: 'failed'
    })
};

