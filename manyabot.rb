require 'unicode'
require 'telegram/bot'

TOKEN = '435455268:AAEyJrD-S1TeX5yIAzJEmzdUDoYskcHTfes'

WORDSTOFILTER = ["маня", "мань"].freeze

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    def validate_message(message)
      WORDSTOFILTER.each do |word|
        Unicode::downcase(message.text).include? word
      end
    end
    bot.api.send_message(chat_id: message.chat.id, text: "#{message.from.first_name}, ты пидор!") if validate_message(message) 
  end
end
