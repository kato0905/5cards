class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast 'room_channel', message: render_message(message), group: render_group(message), length: ActionCable.server.connections.length
  end

  private
    def render_message(message)
      ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
    end
    def render_group(message)
      ApplicationController.renderer.render(partial: 'messages/group', locals: { message: message })
    end
end
