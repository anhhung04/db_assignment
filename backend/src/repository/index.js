const { Pool } = require('pg');
const logger = require('../utils/log');
const process = require('node:process');
const {
    convertObjectToFilterQuery,
    convertObjectToInsertQuery,
    convertObjectToUpdateQuery
} = require("../utils/db");
require('dotenv').config();

const pool = new Pool({
    user: process.env.POSTGRES_USER || 'dev_user',
    host: process.env.POSTGRES_HOST || 'localhost',
    database: process.env.POSTGRES_DB || 'dev_learning_platform',
    password: process.env.POSTGRES_PASSWORD || 'secret',
    port: process.env.POSTGRES_PORT || 5432,
    min: 20,
    max: 100,
});

const getConn = async () => {
    return pool.connect();
};

const execQuery = async (query, args) => {
    let conn = await getConn();
    let result = await conn.query(query, args);
    conn.release();
    return result;
};

class IRepo {
    TIMEOUT = 10_000;
    IS_TRANSACTION = false;
    constructor() { }
    /**
     * Connect to database
     * @returns {boolean} - Connection status
     */
    async connectToDB() {
        try {
            let startTime = Date.now();
            while (!this._session) {
                this._session = await getConn();
                if (Date.now() - startTime > this.TIMEOUT) {
                    throw new Error("Timeout when starting transaction");
                }
            }
            return true;
        } catch (err) {
            logger.debug(err);
            return false;
        }
    }
    /**
     * @typedef {object} QueryObject
     * @property {string} query - Query string
     * @property {Array} args - Query arguments
     */
    /**
     * Execute query in database
     * @param {QueryObject} param0
     * @returns {Promise<Array>} - Query result
     */
    async exec({ query, args }) {
        try {
            if (!this.IS_TRANSACTION) {
                return pool.query(query, args);
            }
            try {
                if (!this._session) {
                    throw new Error("Transaction not started");
                }
                let result = await this._session.query(query, args);
                await this._session.query('COMMIT');
                return result;
            } catch (err) {
                await this._session.query('ROLLBACK');
                throw err;
            }
        } catch (err) {
            logger.error(err);
            return null;
        }
    }
    /**
     * End transaction
     */
    end() {
        if (this._session) {
            this.IS_TRANSACTION = false;
            this._session.release();
            this._session = null;
        }
    }
    /**
     * Start transaction
     * @returns {boolean} - Connection status
     */
    async begin() {
        try {
            this.IS_TRANSACTION = await this.connectToDB();
            this._session.query('BEGIN');
            return true;
        } catch (err) {
            logger.debug(err);
            return false;
        }
    }

    async modifyPermission({ userId, resourceId, permissions, newPermissions = true }) {
        try {
            let query = "", args = [];
            if (newPermissions) {
                query = `
                    INSERT INTO permissions (user_id, resource_id, "create", "read", "update", "delete")
                    VALUES ($1, $2, $3, $4, $5, $6)
                    RETURNING *;
                `;
                args = [userId, resourceId, permissions.create, permissions.read, permissions.update, permissions.delete];
            }
            else {
                let setBuilder = [];
                for (let prop in permissions) {
                    setBuilder.push(`"${prop}" = ${permissions[prop]}`);
                }
                query = `
                    UPDATE permissions
                    SET ${setBuilder.join(",")}
                    WHERE user_id = $1 AND resource_id = $2
                    RETURNING *;
                `;
                args = [userId, resourceId];
            }
            let results = await this.exec({ query, args });
            return {
                permissions: results.rows[0],
                error: null
            }
        } catch (err) {
            logger.error(err);
            return {
                permissions: null,
                error: err
            }
        }
    }

    async findInTable({ table, findObj, limit, page }) {
        limit = limit ? Math.abs(limit) : 10;
        page = page ? Math.abs(page) : 1;
        try {
            if (!findObj) {
                findObj = {
                    "1": "1"
                };
            }
            let { filterQuery, args } = convertObjectToFilterQuery(findObj);
            let query = `
                SELECT *
                FROM ${table}
                WHERE ${filterQuery}
                LIMIT ${limit} OFFSET ${(page - 1) * limit};
            `;
            let results = await this.exec({ query, args });
            return {
                rows: results.rows,
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                rows: [],
                error: err
            };
        }
    }

    async findOneInTable({ table, findObj }) {
        try {
            let {
                rows, error
            } = await this.findInTable({
                table,
                findObj
            });
            if (error) {
                throw new Error(error);
            }
            return {
                row: rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                row: null,
                error: err
            };
        }
    }

    async createInTable({ table, createObj }) {
        try {
            let {
                columns, values, args
            } = convertObjectToInsertQuery(createObj);
            let query = `
                INSERT INTO ${table} (${columns})
                VALUES (${values})
                RETURNING *;
            `;
            await this.begin();
            let results = await this.exec({ query, args });
            await this.end();
            return {
                row: results.rows[0],
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                row: null,
                error: err
            };
        }
    }

    async updateInTable({ table, indentify, updateObj }) {
        try {
            let {
                filterQuery, args: argsFilter
            } = convertObjectToFilterQuery(indentify);
            let {
                updateQuery, args: argsUpdate
            } = convertObjectToUpdateQuery(updateObj, argsFilter.length + 1);
            let query = `
                UPDATE ${table}
                SET ${updateQuery}
                WHERE ${filterQuery}
                RETURNING *;
            `;
            let args = [...argsFilter, ...argsUpdate];
            await this.begin();
            let results = await this.exec({ query, args });
            await this.end()
            return {
                rows: results.rows,
                error: null
            };
        } catch (err) {
            logger.debug(err);
            return {
                rows: null,
                error: err
            };
        }
    }
}

module.exports = {
    getConn,
    execQuery,
    IRepo,
    pool
};