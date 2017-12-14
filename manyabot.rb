require 'unicode'
require 'telegram/bot'

token = '435455268:AAEyJrD-S1TeX5yIAzJEmzdUDoYskcHTfes'

class Validator

	WORDSTOFILTER = ["маня", "мань"].freeze
	
	def validateMessage(message)
		WORDSTOFILTER.each do |word|
			if Unicode::downcase(message).include? word
				return false
			end
		end
		return true
	end
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
  	unless Validator.new.validateMessage(message.text)
  		bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, ты пидор!")
  	end
  end
end