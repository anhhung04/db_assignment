const { IRepo } = require("./index");
const logger = require("../utils/log");
const {
    convertObjectToFilterQuery,
    convertObjectToInsertQuery,
    convertObjectToUpdateQuery
} = require("../utils/db");

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
            logger.debug(err);
            return {
                course: null,
                error: err
            };
        }
    }
    async find({ limit, offset }) {
        try {
            const result = await this.exec({
                query: `SELECT * FROM courses LIMIT $1 OFFSET $2;`,
                args: [limit, offset]
            });
            return {
                courses: result.rows,
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                courses: [],
                error: err
            };
        }
    }
    async create(newObj) {
        let { columns, values, args } = convertObjectToInsertQuery(newObj);
        try {
            const result = await this.exec({
                query: `
                    INSERT INTO courses (${columns}) 
                    VALUES (${values}) 
                    RETURNING *;
                `,
                args
            });
            return {
                course: result.rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                course: null,
                error: err
            };
        }
    }

    async findByIdAndUpdate(id, updateObj) {
        try {
            let { updateQuery, args } = convertObjectToUpdateQuery(updateObj, 2);
            const result = await this.exec({
                query: `
                    UPDATE courses
                    SET ${updateQuery}
                    WHERE course_id = $1
                    RETURNING *;
                `,
                args: [id, ...args]
            });
            return {
                course: result.rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                course: null,
                error: err
            };
        }
    }

    async search({ content, limit }) {
        try {
            const result = await this.exec({
                query: `
                    SELECT * FROM courses
                    WHERE title LIKE $1 OR description LIKE $1 OR content_info LIKE $1
                    LIMIT $2;
                `,
                args: [`%${content}%`, limit]
            });
            return {
                courses: result.rows,
                error: null
            };
        }
        catch (err) {
            logger.debug(err);
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