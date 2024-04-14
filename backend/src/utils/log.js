const pino = require('pino');

const logger = pino({
    formatters: {
        level: (label) => ({ level: label.toUpperCase() }),
        timestamp: pino.stdTimeFunctions.isoTime,
    },
    transport: {
        target: 'pino-pretty',
        options: {
            colorize: true,
        },
    }
});

module.exports = logger;