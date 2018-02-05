class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    #ActionCable.server.broadcast 'room_channel', message: data['message']
    if data['check'] == 0 then
      Message.create! content: data['message'], group: data['house']
    #elsif data['check'] == 1 && data['group'] == 2 then
    #  Message.create! content: data['message'], group: data['group']
    #elsif data['check'] == 2 && data['group'] == 1 then
    #  Message.create! content: data['message'], group: data['group']
    end
  end
end
