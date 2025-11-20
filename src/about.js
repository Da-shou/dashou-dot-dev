'use strict';

/**
 * Render the view index.ejs, serving as home page.
 * @param req
 * @param res
 */
exports.index = function(req, res){
    res.render('about/about.ejs', { title: 'About' });
};