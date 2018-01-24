require 'json'
require 'net/http'
require 'telegram/bot'
require 'unicode'

MANYAFILTER = ["маня", "мань"]
VYNOSITE = ["выносите"]
BOOBS = ["сиськи"]
BUTTS = ["жопа"]

class Validator
  def handleMessage(message, keyWords, handler)
    unless validateMessage(message, keyWords)
      handler.call()
    end
  end

  def validateMessage(message, filterList)
    filterList.each do |word|
      message = removeRepetitiveSymbols(message)
      if Unicode::downcase(message).include? word
	      return false
      end
    end
    return true
  end
  def removeRepetitiveSymbols(text)
    return text.gsub(/(.*)\1+/, '\1')
  end
end

class ReplyComposer
  def sendEmergencyPicture(bot, chatId)
    bot.api.send_photo(chat_id: chatId, photo: "https://i.imgur.com/ERaRFiD.jpg", disable_notification: true)
  end

  def replyManya(bot, message)
    bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name} остынь, он не манька, он #нетакойкаквсе!!")
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
end

Telegram::Bot::Client.run(ENV["TOKEN"]) do |bot|
  validator = Validator.new
  replyComposer = ReplyComposer.new
  bot.listen do |message|
    unless message.nil? or message.text.nil? then
      text = message.text
      chatId = message.chat.id
      validator.handleMessage(text, BOOBS, Proc.new { replyComposer.sendBoobs(bot, chatId) })
      validator.handleMessage(text, BUTTS, Proc.new { replyComposer.sendButts(bot, chatId) })
      validator.handleMessage(text, MANYAFILTER, Proc.new { replyComposer.replyManya(bot, message) })
      validator.handleMessage(text, VYNOSITE, Proc.new { replyComposer.sendEmergencyPicture(bot, chatId) })
    end
  end
 end
