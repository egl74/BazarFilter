#require 'rubygems'
#require 'unicode_normalize'
require 'telegram/bot'

class Validator

	WORDSTOFILTER = ["маня", "мань"].freeze
	
	def validateMessage(message)
		WORDSTOFILTER.each do |word|
			#if Unicode::downcase(message).include? word
			if message.downcase.include? word
				return false
			end
		end
		return true
	end
end

Telegram::Bot::Client.run(ENV["TOKEN"]) do |bot|
  bot.listen do |message|
  	unless message.nil? or message.text.nil? or Validator.new.validateMessage(message.text)
  		bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, ты пидор!")
  	end
  end
end