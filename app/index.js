const express = require('express');
const server = express();

server.get('*', (req, res) => {
    res.json(req.headers);
});

server.listen(process.env.PORT || process.env.npm_package_config_port);
