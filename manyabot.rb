require 'telegram/bot'
require 'unicode'

MANYAFILTER = ["маня", "мань"]
VYNOSITE = ["выносите"]
BOOBS = ["сиськи"]
BUTTS = ["жопа"]

class Validator
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

Telegram::Bot::Client.run(ENV["TOKEN"]) do |bot|
  validator = Validator.new
  bot.listen do |message|
    unless message.nil? or message.text.nil? then
      unless validator.validateMessage(message.text, BOOBS)
        bot.api.send_photo(chat_id: message.chat.id, photo: "https://i.imgur.com/ERaRFiD.jpg", disable_notification: true)
      end
      unless validator.validateMessage(message.text, MANYAFILTER)
        bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name} остынь, он не манька, он #нетакойкаквсе!!")
      end
      unless validator.validateMessage(message.text, VYNOSITE)
	bot.api.send_photo(chat_id: message.chat.id, photo: "https://i.imgur.com/ERaRFiD.jpg", disable_notification: true)
      end
    end
  end
 end
