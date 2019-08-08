class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:chat_id]}"
  end

  def unsubscribed
  end

  def receive(data)
    puts data
    chat = Chat.find_or_create_by(id: params[:chat_id])
    new_message = Message.create(body: data["message"], user: User.find(data["user"]["user_id"]))
    chat.messages << new_message

    chat_key = chat.id

    chat_json = {
      "chat_key": chat_key,
      "message": new_message.body,
      "messageId": new_message.id,
      "user": data["user"]
    }

    ActionCable.server.broadcast("chat_#{params[:chat_id]}", chat_json)
  end

end
