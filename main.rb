require './stockWatcher'
require './validator'
require './replyComposer'
require 'telegram/bot'

MANYAFILTER = ["маня", "мань"]
VYNOSITE = ["выносите"]
BOOBS = ["сиськи", "/boobs"]
BUTTS = ["жопа", "/butts"]
QUOTES = ["/btc", "/eth", "/eur"]

Telegram::Bot::Client.run(ENV["TOKEN"]) do |bot|
  validator = Validator.new
  replyComposer = ReplyComposer.new
  stockWatcher = StockWatcher.new
  bot.listen do |message|
    unless message.nil? or message.text.nil? or message.text.empty? then
      text = message.text
      chatId = message.chat.id
      validator.handleMessage(text, QUOTES, Proc.new { replyComposer.sendText(stockWatcher.getQuote(text)) })
      validator.handleMessage(text, BOOBS, Proc.new { replyComposer.sendBoobs(bot, chatId) })
      validator.handleMessage(text, BUTTS, Proc.new { replyComposer.sendButts(bot, chatId) })
      validator.handleMessage(text, MANYAFILTER, Proc.new { replyComposer.replyManya(bot, message) }, true)
      validator.handleMessage(text, VYNOSITE, Proc.new { replyComposer.sendEmergencyPicture(bot, chatId) })
    end
  end    
end
