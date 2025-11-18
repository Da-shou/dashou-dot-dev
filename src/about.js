'use strict';

exports.index = function(req, res){
    res.render('about/about.ejs', { title: 'About' });
};