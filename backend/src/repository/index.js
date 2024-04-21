const { Pool } = require('pg');
const logger = require('../utils/log');
const process = require('node:process');
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
}

module.exports = {
    getConn,
    execQuery,
    IRepo,
    pool
};