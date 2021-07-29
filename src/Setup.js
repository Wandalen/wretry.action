const ChildProcess = require( 'child_process' );

ChildProcess.execSync( 'npm i --production', { stdio : 'inherit', cwd : __dirname } );
