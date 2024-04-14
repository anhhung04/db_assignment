const { execSync } = require('child_process');
const { join } = require('path');
const { upAll, exec } = require('docker-compose');
const dotenv = require('dotenv');

module.exports = async () => {
    console.time('global-setup');
    dotenv.config({ path: '.env.test' });

    console.log('\nStarting up dependencies please wait...\n');
    await upAll({
        cwd: join(__dirname), // eslint-disable-line no-undef
        log: true
    });

    await exec('database', ['sh', '-c', 'until pg_isready ; do sleep 1; done'], {
        cwd: join(__dirname) // eslint-disable-line no-undef
    });
    // 3
    console.log('Dependencies are ready, running migrations...');
    console.log('Running migrations...');
    execSync('yarn migrate:up');
    console.log('Migrations are done, connecting redis...');

    console.timeEnd('global-setup');
};