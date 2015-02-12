// Generated by CoffeeScript 1.9.0
(function() {
  var current, score, socket, total, uuid, wins;

  socket = io.connect();

  current = '';

  uuid = '';

  wins = 0;

  total = 0;

  score = 'まだ始まってないよ';

  socket.on('login', function(data) {
    uuid = data['uuid'];
    current = data['current'];
    $("#keyword").text(current);
    $("#textbox").val('');
    return $("#score").text(score);
  });

  socket.on('notify', function(data) {
    total += 1;
    if (data['uuid'] === uuid) {
      $("#messages").append('<li>' + data['before'] + '</li>');
      wins += 1;
    } else {
      $("#messages").append('<li class="lose">' + data['before'] + '</li>');
    }
    current = data['current'];
    $("#keyword").text(current);
    $("#textbox").val('');
    score = wins / total * 100;
    $("#score").text(score + '%(' + wins + '/' + total + ')');
  });

  $(window).keydown(function(e) {
    if (e.which === 13) {
      if (current === $("#textbox").val()) {
        socket.emit('send', {
          uuid: uuid,
          answer: $("#textbox").val()
        });
      } else {
        console.log($("#textbox").val());
        alert("まちがってるよ!!!");
      }
    }
  });

}).call(this);