socket = io.connect()
current = ''
uuid = ''
wins = 0
total = 0
score = 'まだ始まってないよ'

socket.on 'login',(data) ->
  uuid = data['uuid']
  current = data['current']
  $("#keyword").text current
  $("#textbox").val('')
  $("#score").text score

socket.on 'updateMembers', (members) ->
  $("#members").text members

socket.on 'notify', (data) ->
  total += 1
  if data['uuid'] is uuid
    $("#messages").prepend '<li>' + data['before'] + '</li>'
    wins += 1
  else
    $("#messages").prepend('<li class="lose">' + data['before'] + '</li>') 
  current = data['current']
  $("#keyword").text current
  $("#textbox").val('')
  score = Math.floor(wins / total * 100)
  $("#score").text (score + '%(' + wins + '/' + total + ')')
  return

$(window).keydown (e) ->
  if e.which is 13
    if current is $("#textbox").val()
      socket.emit 'send', {uuid: uuid, answer: $("#textbox").val()}
    else
      $('body').css('background-color','red')
      $(this).delay(500).queue -> 
        $('body').css('background-color', 'white')
        $(this).dequeue()
  return
