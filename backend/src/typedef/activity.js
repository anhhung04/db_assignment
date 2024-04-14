const { UUID } = require('./validator'); //eslint-disable-line no-unused-vars
/**
 * @typedef {Object} Activity
 * @property {Number} id - Activity id
 * @property {UUID} activistId - User id
 * @property {UUID} resourceId - Resource id
 * @property {String} action - Action type
 * @property {String} note - Note
 * @property {Date} created_at - Created date
 * @property {Date} updated_at - Updated date
 */