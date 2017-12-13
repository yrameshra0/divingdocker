const express = require('express');
const path = require('path');
const favicon = require('serve-favicon');
const logger = require('morgan');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');

const index = require('./routes/index');
const users = require('./routes/users');

const app = express();

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


app.use('/', index);
app.use('/users', users);

app.use(function(request, response, next){
    const error = new Error('Not Found');
    error.status = 404;

    next(error);
});

app.use(function(error, request, response, next){
    response.locals.message = error.message;
    response.locals.error = request.app.get('env') === 'development' ? error : {};

    response.status(error.status || 500);
    response.render('error');
})

module.exports = app;
