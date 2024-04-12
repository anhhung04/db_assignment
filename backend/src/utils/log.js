const pino = require('pino');

const logger = pino({
    formatters: {
        level: (label) => ({ level: label.toUpperCase() }),
        timstamp: pino.stdTimeFunctions.isoTime,
    }
});

module.exports = logger;