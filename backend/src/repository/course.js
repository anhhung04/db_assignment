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
                query: `SELECT * FROM courses WHERE ${filterQuery};`,
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

    async findLessons(courseId, filterObj = null) {
        try {
            let filterBuilder = "course_id = $1";
            let argsBuilder = [courseId];
            if (filterObj) {
                let { filterQuery, args } = convertObjectToFilterQuery(filterObj, 2);
                filterBuilder = `${filterBuilder} AND ${filterQuery}`;
                argsBuilder = [...argsBuilder, ...args];
            }
            const result = await this.exec({
                query: `
                    SELECT * FROM lessons
                    WHERE ${filterBuilder}
                `,
                args: argsBuilder
            });
            return {
                lessons: result.rows,
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                lessons: [],
                error: err
            };
        }
    }

    async createLesson(newObj) {
        let { columns, values, args } = convertObjectToInsertQuery(newObj);
        try {
            const result = await this.exec({
                query: `
                    INSERT INTO lessons (${columns})
                    VALUES (${values})
                    RETURNING *;
                `,
                args
            });
            if (result.rows?.length !== 1) {
                return {
                    lesson: null,
                    error: "Lesson not created"
                };
            }
            return {
                lesson: result.rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                lesson: null,
                error: err
            };
        }
    }

    async updateLesson(lessonId, updateObj) {
        try {
            let { updateQuery, args } = convertObjectToUpdateQuery(updateObj, 2);
            const result = await this.exec({
                query: `
                    UPDATE lessons
                    SET ${updateQuery}
                    WHERE id = $1
                    RETURNING *;
                `,
                args: [lessonId, ...args]
            });
            return {
                lesson: result.rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                lesson: null,
                error: err
            };
        }

    }
}

module.exports = {
    CourseRepo
};