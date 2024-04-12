const { execSync } = require('child_process');
const { join } = require('path');
const { upAll, exec } = require('docker-compose');
const dotenv = require('dotenv');

module.exports = async () => {
    console.time('global-setup');
    dotenv.config({ path: '.env.test' });

    console.log('\nStarting up dependencies please wait...\n');
    await upAll({
        cwd: join(__dirname),
        log: true
    });

    await exec('database', ['sh', '-c', 'until pg_isready ; do sleep 1; done'], {
        cwd: join(__dirname)
    });
    // 3
    console.log('Running migrations...');
    execSync('yarn migrate:up');

    console.timeEnd('global-setup');
};