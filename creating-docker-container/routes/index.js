const express = require('express');
const router = express.Router();

router.get('/', function(request, response, next){
    console.log("I'm HERE");
    response.render('index', {title: 'Node.js Express App'});
});

module.exports = router;