const { IRepo } = require("./index");
const { convertObjectToFilterQuery } = require("../utils/db");

class CourseRepo extends IRepo {
    constructor() {
        super();
    }
    async findOne(getObj) {
        try {
            const { filterQuery, args } = convertObjectToFilterQuery(getObj);
            const result = await this.exec({
                query: `SELECT * FROM course WHERE ${filterQuery}`,
                args
            });
            if (result.rows?.length !== 1) {
                return {
                    course: null,
                    error: "Course not found"
                };
            }
            return {
                course: result.rows[0],
                error: null
            };
        } catch (err) {
            return {
                course: null,
                error: err
            };
        }
    }
    async find({ limit, offset }) {
        try {
            const result = await this.exec({
                query: `SELECT * FROM course LIMIT $1 OFFSET $2;`,
                args: [limit, offset]
            });
            return {
                courses: result.rows,
                error: null
            };
        } catch (err) {
            return {
                courses: [],
                error: err
            };
        }
    }
}

module.exports = {
    CourseRepo
};