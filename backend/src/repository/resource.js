const { IRepo } = require("./index");
const logger = require("../utils/log");
class ResourceRepo extends IRepo {
    constructor() {
        super();
        this.resourceTables = ["videos", "documents"];
    }

    async findOne({ table, id }) {
        try {
            if (!this.resourceTables.includes(table)) {
                return {
                    resource: null,
                    error: new Error("Invalid table")
                };
            }
            let query = `
                SELECT *
                FROM learning_resources
                JOIN ${table} ON learning_resources.id = ${table}.id
                WHERE learning_resources.id = $1
            `;
            let args = [id];
            let result = await this._session.query(query, args);
            if (result.rows.length !== 1) {
                return null;
            }
            return {
                resource: result.rows[0],
                error: null
            };
        }
        catch (err) {
            logger.error(err);
            return {
                resource: null,
                error: err
            };
        }
    }

    async checkStudentAccess({ userId, resourceId }) {
        try {
            let query = `
                SELECT *
                FROM students_join_courses jc
                JOIN lessons ls ON jc.course_id = ls.course_id AND jc.student_id = $1
                JOIN lesson_resources lr ON ls.id = lr.lesson_id
                WHERE lr.resource_id = $2
            `;
            let args = [userId, resourceId];
            let result = await this._session.query(query, args);
            return {
                access: result.rows.length >= 1,
                error: null
            };
        }
        catch (err) {
            logger.error(err);
            return {
                access: false,
                error: err
            };
        }
    }
}

module.exports = {
    ResourceRepo
};