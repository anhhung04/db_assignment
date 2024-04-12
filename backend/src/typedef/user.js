const { Email, UUID } = require('./validator'); //eslint-disable-line no-unused-vars

/**
 * @typedef {Object} Permissions
 * @property {Boolean} read - Read permission
 * @property {Boolean} create - Create permission
 * @property {Boolean} delete - Delete permission
 * @property {Boolean} update - Update permission 
*/

/**
 * @typedef {Object} User
 * @property {UUID} id - User id
 * @property {String} username - User username
 * @property {Email} email - User email
 * @property {String} password - User password
 * @property {String} firstName - User first name
 * @property {String} lastName - User last name
 * @property {Permissions} generalPermissions - User general permissions
 * @property {Date} created_at - User created date
 * @property {Date} updated_at - User updated date
 */