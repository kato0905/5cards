# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
check = 0 #0:誰も何も選んでない,1:PlayerXがカードを選択,2:PlayerYがカードを選択,3:両方ともがカードを選択
turn = 1 #ターン（最大５ターン）
opposite = 0
my = 0 #自分の出したカード
your = 0 #相手の出したカード
current = 0 #現ターンで取得した/された点数
sum = 0 #自分の点数
ysum = 0 #相手の点数
house = 0 #入っているルーム
App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if String(data['group'].replace(/\r?\n/g,"")) is String(house)
      #alert(data['group']+house)
      $('#messages').append("<img src='/assets/card/z1.png'>")
      if check is 0 and opposite is 0 #他プレイヤーが選択(１枚目)
        opposite = 2
        your = data['message'].slice(47).slice(0,-14)
      else if check is 1 and opposite is 2 #自分が選択(２枚目)
        check = 2
        my = data['message'].slice(47).slice(0,-14)
      else if check is 1 and opposite is 0 #自分が選択(１枚目)
        opposite = 1
        my = data['message'].slice(47).slice(0,-14)
      else if check is 1 and opposite is 1 #他プレイヤーが選択(２枚目)
        check = 2
        your = data['message'].slice(47).slice(0,-14)
      if check is 2 #ターン終了時の処理
        check = 0
        turn = turn + 1
        opposite = 0
        current = parseInt(my,10) + parseInt(your,10)
        $('#messages').append("<br>あなたが選んだカードは")
        $('#messages').append("<img src='/assets/card/"+parseInt(my,10)+".png'><br>")
        $('#messages').append("<br>相手が選んだカードは")
        $('#messages').append("<img src='/assets/card/"+parseInt(your,10)+".png'><br>")
        if parseInt(my,10) > parseInt(your,10)
          sum = sum + parseInt(my,10) + parseInt(your,10)
          $('#messages').append("<strong>You win</strong><span> and Get POINT "+current+"</span><br>")
          $('#point').empty()
          $('#point').append(sum)
        else if parseInt(your,10) > parseInt(my,10)
          $('#messages').append("<strong>You lose</strong><br>")
          ysum = ysum + parseInt(my,10) + parseInt(your,10)
          $('#point').empty()
          $('#point').append(sum)
        else if parseInt(my,10) is parseInt(your,10)
          $('#messages').append("<strong>Draw</strong><br>")
          $('#point').empty()
          $('#point').append(sum)
        if turn is 6
          $('#messages').append("<br><strong>ゲーム終了</strong>")
          $('#messages').append("<br>あなたの得点は"+sum+",相手の得点は"+ysum)
          if sum > ysum
            $('#messages').append("<br><strong>あなたの勝利</strong>")
          else if ysum > sum
            $('#messages').append("<br><strong>あなたの負け</strong>")
          else if sum is ysum
            $('#messages').append("<br><strong>引き分け</strong>")
      #alert("You select ["+data['message'].slice(27).slice(0,-17)+"] Please wait");
        # Called when there's incoming data on the websocket for this channel
  speak: (message,group,check,house) ->
    @perform 'speak', message: message, group: group, check:check, house:house

  $ ->
    house = $('.roomname').val()

  $(document).on 'click', '[data-behavior~=room_speaker]', (event) ->
    #if event.keyCode is 13 # return = send
    #App.room.speak event.target.value, $('#group').val()
    #if event.target.value isnt 'selected'
    if event.target.value isnt 'selected'
      #alert("check is "+check+" ¥¥ gcheck is "+gcheck)
      house = $('#house').val()
      App.room.speak event.target.value, $('#group').val(), check, $('#house').val()
      $("#group").prop("disabled", true) #Playerを固定
      if check is 0
        event.target.value = 'selected'
        $(this).css 'opacity','0.3'
        check = 1
      else if check is 1
        alert("相手がカードを選ぶまでお待ちください")
      event.preventDefault()
    else
      event.preventDefault()
