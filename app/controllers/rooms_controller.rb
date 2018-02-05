class RoomsController < ApplicationController
  def show
    @messages = Message.all
  end

  def reset
    Message.delete_all
    @messages = Message.all
    redirect_to action: :show
  end

  def index

  end
end
