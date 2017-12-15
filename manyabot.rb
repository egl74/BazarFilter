require 'telegram/bot'

MANYAFILTER = ["маня", "мань"]
VYNOSITE = ["выносите"]

class Validator

	def validateMessage(message, filterList)
		filterList.each do |word|
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
  validator = Validator.new
  bot.listen do |message|
		unless message.nil? or message.text.nil? then
      	unless validator.validateMessage(message.text, MANYAFILTER)
  				bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name} остынь, он не манька, он #нетакойкаквсе!!")
        end
      	unless validator.validateMessage(message.text, VYNOSITE)
					bot.api.send_message(chat_id: message.chat.id, text: "https://i.imgur.com/ERaRFiD.jpg")
        end
    end
  end
end
