
const http = require('http');
const app = require('./app');
const app_configuration = require('config');
const server = http.createServer(app);
const port = process.env.PORT || app_configuration.get('server.port');
server.timeout = 0;
console.log(port);
server.listen(port);

//Catching uncaught exceptions
process.on('uncaughtException', err => {
	console.error('[server.js:12] There was an uncaught error: ', err)
	process.exit(1) //mandatory (as per the Node.js docs)
});

//quit on ctrl-c when running docker in terminal
process.on('SIGINT', function onSigint() {
	console.info('Got SIGINT (aka ctrl-c in docker). Graceful shutdown', new Date().toISOString());
	shutdown();
});

//quit properly on docker stop
process.on('SIGTERM', function onSigterm() {
	console.info('Got SIGTERM (docker container stop). Graceful shutdown', new Date().toISOString());
	shutdown();
});

//shut down server
function shutdown() {
	server.close(function onServerClosed(err) {
		if(err) {
			console.error(err);
			process.exitCode = 1;
		}
		process.exit();
	});
}

// Better: connection tracking
//https://github.com/hunterloftis/stoppable
