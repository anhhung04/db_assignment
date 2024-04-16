const { IRepo } = require('./index');
const { v4: uuidv4 } = require('uuid');
const { UUID } = require("../typedef/validator");
const logger = require("../utils/log");
const { convertObjectToFilterQuery, convertObjectToInsertQuery } = require("../utils/db");
class UserRepo extends IRepo {
    /** 
     * Initialize user repository
    */
    constructor() {
        super();
    }
    /**
     * @typedef {object} UserQueryResponse
     * @property {import("../typedef/user").User} user - User object
     * @property {Error} error - Error object
     */
    /**
     * Find user by id
     * @param {UUID} id
     * @returns {Promise<UserQueryResponse>} - User object
     */
    async findById(id) {
        try {
            if (!(id instanceof UUID)) {
                throw new Error("Invalid user id");
            }
            let results = await this.exec({
                query: `
                SELECT users.*,
                user_permissions.read,
                user_permissions.create,
                user_permissions.delete,
                user_permissions.update
                FROM (
                        SELECT *
                        FROM users
                        WHERE id = $1
                    ) AS users
                    LEFT JOIN (
                        SELECT *
                        FROM permissions
                        WHERE permissions.user_id = $1
                            AND permissions.resource_id = '00000000-0000-0000-0000-000000000000'
                    ) as user_permissions 
                ON users.id = user_permissions.user_id;
                `,
                args: [id]
            });
            if (results.rowCount !== 1) {
                throw new Error("Query database error");
            }
            let row = results.rows[0];
            return ({
                user: {
                    id: row.id,
                    username: row.username,
                    email: row.email,
                    password: row.password,
                    firstName: row.fname,
                    lastName: row.lname,
                    generalPermissions: {
                        read: row.read,
                        create: row.create,
                        delete: row.delete,
                        update: row.update
                    },
                    role: row.account_type,
                    created_at: row.created_at,
                    updated_at: row.updated_at,
                }, error: null
            });
        } catch (err) {
            logger.error(err);
            return {
                user: null,
                error: err
            };
        }
    }

    /**
     * @typedef {object} QueryPermission
     * @property {UUID} userId - User id
     * @property {UUID} resourceId - Resource id
     * @property {string} actionType - Action type
     */
    /**
     * Check user permissions
     * @param {QueryPermission} param0
     * @returns {Promise<Object>} - User permission
     */
    async fetchUserPermissions({ userId, resourceId }) {
        try {
            let results = await this.exec({
                query: `
                SELECT *
                FROM permissions
                WHERE user_id = $1
                    AND resource_id = $2
                `,
                args: [userId, resourceId]
            });
            if (results.rowCount !== 1) {
                throw new Error("Query database error");
            }
            let row = results.rows[0];
            delete row.user_id;
            delete row.resource_id;
            return {
                permissions: row,
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                permissions: null,
                error: err
            };
        }
    }
    /**
     * @param {Object} findObject
     * @returns {Promise<UserQueryResponse>}
     */
    async find(findObject) {
        try {
            let { filterQuery, args } = convertObjectToFilterQuery(findObject);
            let results = await this.exec({
                query: `
                    SELECT *
                    FROM users
                    WHERE ${filterQuery};
                `,
                args
            });
            if (results?.rowCount !== 1) {
                throw new Error("Query database error");
            }
            let userId = results.rows[0].id;
            return this.findById(userId);
        } catch (err) {
            logger.debug(err);
            return {
                user: null,
                error: err
            };
        }
    }

    async create(newUser) {
        Object.assign(newUser, {
            id: uuidv4(),
            account_type: "user",
            status: "active",
        });
        let { columns, values, args } = convertObjectToInsertQuery(newUser);
        try {
            let results = await this.exec({
                query: `
                    INSERT INTO users(${columns})
                    VALUES(${values})
                    RETURNING *;
                `,
                args
            });
            if (results.rowCount !== 1) {
                throw new Error("Query database error");
            }
            let userId = results.rows[0].id;
            return this.findById(userId);
        } catch (err) {
            logger.debug(err);
            return {
                user: null,
                error: err
            };
        }
    }
}


module.exports = {
    UserRepo
};