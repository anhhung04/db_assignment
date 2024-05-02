const { IRepo } = require('./index');
const { v4: uuidv4, validate } = require('uuid');
const logger = require("../utils/log");
const { convertObjectToFilterQuery, convertObjectToInsertQuery } = require("../utils/db");
class UserRepo extends IRepo {
    constructor() {
        super();
    }

    async findById(id) {
        try {
            if (!validate(id)) {
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
                    displayName: row.display_name,
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
            await this.exec({
                query: `
                    INSERT INTO permissions(user_id, resource_id, "read", "create", "delete", "update")
                    VALUES($1, '00000000-0000-0000-0000-000000000000', false, false, false, false);
                `,
                args: [userId]
            });
            return this.findById(userId);
        } catch (err) {
            logger.debug(err);
            return {
                user: null,
                error: err
            };
        }
    }

    async createUserType({ userId, userType, typeData }) {
        let { columns, values, args } = convertObjectToInsertQuery(typeData, 2);
        try {
            await this.exec({
                query: `
                    INSERT INTO ${userType}(user_id, ${columns})
                    VALUES($1, ${values});
                `,
                args: [userId, ...args]
            });
            return {
                success: true,
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                success: false,
                error: err
            };
        }

    }
}


module.exports = {
    UserRepo
};