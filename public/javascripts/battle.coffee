socket = io.connect()
current = ''
uuid = ''
wins = 0
total = 0
score = 'まだ始まってないよ'
$("#myCount").text 0
$("#enemyCount").text 0


socket.on 'login',(data) ->
  uuid = data['uuid']
  current = data['current']
  $("#keyword").text current
  $("#textbox").val('')
  $("#score").text score

socket.on 'enemy', (data) ->
  $("#enemysinput").val(data)

socket.on 'updateMembers', (members) ->
  $("#members").text members
  if members > 1
    $("#textbox").val('')
    $("#textbox").removeAttr('disabled')
    $("#keyword").text current
  else
    $("#textbox").val('')
    $("#textbox").attr('disabled','disabled')
    $("#keyword").text ""

socket.on 'notify', (data) ->
  total += 1
  if data['uuid'] is uuid
    $("#myWords").prepend '<li>' + data['before'] + '</li>'
    wins += 1
    $("#myCount").text wins
  else
    $("#enemyWords").prepend('<li class="lose">' + data['before'] + '</li>') 
    $("#enemyCount").text (total - wins)
  current = data['current']
  $("#keyword").text current
  $("#textbox").val('')
  score = Math.floor(wins / total * 100)
  $("#score").text (score + '%(' + wins + '/' + total + ')')

  if wins >= 10 or total - wins >= 10
    $("#textbox").val ''
    $("#textbox").attr('disabled','disabled')
    if wins >= 10
        alert 'You Win'
    else
        alert 'You lose'

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
  else
    socket.emit 'current' , $("#textbox").val()
  return
