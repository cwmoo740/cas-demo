const express = require('express');
const cas = require('connect-cas');
const session = require('cookie-session');

cas.configure({
    host: 'cas-demo.org',
    protocol: 'https',
    service: 'https://cas-demo.org/app/protected'
});

const server = express();
server.use(session({secret: 'very secret'}));

function response(req, res) {
    res.json({
        headers: req.headers,
        host: req.hostname
    });
}

server.get('/protected', cas.serviceValidate(), cas.authenticate(), response);

server.get('*', response);

server.use((err, req, res, next) => {
    console.error(err);
    console.error(err.stack);
    next(err);
});

const port = process.env.PORT || process.env.npm_package_config_port;

server.listen(port, () => console.log('listening on port', port));
