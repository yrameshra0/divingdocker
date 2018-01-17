const express = require('express');
const router = express.Router();

router.get('/', function(request, response, next){
    response.send('response with a resource');
});

module.exports = router;