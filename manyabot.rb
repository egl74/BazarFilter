require 'telegram/bot'

WORDSTOFILTER = ["маня", "мань"]

class Validator

	def validateMessage(message)
		WORDSTOFILTER.each do |word|
			# TODO: replace with solid downcase
			message = removeRepetitiveSymbols(message)
			if message.downcase.include? word
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
  bot.listen do |message|
  	unless message.nil? or message.text.nil? or Validator.new.validateMessage(message.text)
  		bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name} не манька, он #нетакойкаквсе!")
  	end
  end
end
