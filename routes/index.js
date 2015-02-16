
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Express Typing Battle!!!!', src: 'event'})
};
exports.index2 = function(req, res){
  res.render('index2', { title: 'Express Typing Battle!!!!', src: 'battle'})
};
