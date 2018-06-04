const http = require('http');
const cluster = require('cluster');
const numCPUs = require('os').cpus().length;
const hostname = '0.0.0.0';
const port = 9292;

if (cluster.isMaster) {
        for (var i = 0; i < numCPUs; i++)
                cluster.fork();
} else {
        http.createServer(function(req, res) {
                res.writeHead(200, { 'Content-Type': 'text/plain' });
                res.end('Hello World');
        }).listen(port, hostname);
}
