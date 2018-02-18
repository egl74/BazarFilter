require 'json'

class ReplyComposer
  def sendEmergencyPicture(bot, chatId)
    bot.api.send_photo(chat_id: chatId, photo: "https://i.imgur.com/ERaRFiD.jpg", disable_notification: true)
  end

  def replyManya(bot, message)
    sendText(bot, message.chat.id, "#{message.from.first_name} остынь, он не манька, он #нетакойкаквсе!!")
  end

  def sendBoobs(bot, chatId)
    sendNude(bot, chatId, "boobs")
  end

  def sendButts(bot, chatId)
    sendNude(bot, chatId, "butts")
  end

  def sendNude(bot, chatId, query)
    apiUrl = "http://api.o#{query}.ru/#{query}/1/1/random"
    result = JSON.parse(Net::HTTP.get(URI.parse(apiUrl)))
    randomId = result[0]["id"]
    bot.api.send_photo(chat_id: chatId, photo: "media.o#{query}.ru/#{query}/#{"%05d" % randomId}.jpg", disable_notification: true)
  end

  def sendText(bot, chatId, messageText)
    bot.api.send_message(chat_id: chatId, text: messageText)
  end
end