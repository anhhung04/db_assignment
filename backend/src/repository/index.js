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
});

const getConn = () => {
    return pool.connect();
};

const execQuery = async (query, args) => {
    let conn = await getConn();
    let result = await conn.query(query, args);
    conn.release();
    return result;
};

class IRepo {
    constructor() {
        this._session = null;
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
            if (!this._session) {
                throw new Error("Session not found! Please start transaction first.");
            }
            return this._session.query(query, args);
        } catch (err) {
            logger.error(err);
            return null;
        }
    }
    /**
     * Close repository
     */
    close() {
        this._session.release();
    }
    /**
     * Start transaction
     */
    async begin() {
        try {
            this._session = await getConn();
        } catch (err) {
            logger.error(err);
        }
    }
}

module.exports = {
    getConn,
    execQuery,
    IRepo
};