const http = require('http');
const cluster = require('cluster');
const numCPUs = 3;
const hostname = '0.0.0.0';
const port = 7000;

if (cluster.isMaster) {
        for (var i = 0; i < numCPUs; i++) {
                cluster.fork();
        }
} else {
        http.createServer(function(req, res) {
                res.writeHead(200, { 'Content-Type': 'text/plain' });
                res.end('Hello World');
        }).listen(port, hostname);
}
