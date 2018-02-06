require 'json'
require 'net/http'
require 'nokogiri'
require 'open-uri'
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

class StockWatcher
  def getQuote(symbol, bot, chatId)
    bot.api.send_message(chat_id: chatId, text: fetchQuote(symbol))
  end

  def fetchQuote(symbol)
    quote = ""
    diff = ""
    url = "https://finance.yahoo.com/quote/#{symbol}USD=X"
    begin
      doc = Nokogiri::HTML(open(url))
      sleep(1)
      doc.xpath('//*[@id="quote-header-info"]/div[3]/div[1]/span/text()').each do |q|
        quote = "#{sprintf('%.2f', q.to_s.delete(',').to_f)}$"
      end
      doc.xpath('//*[@id="quote-header-info"]/div[3]/div[1]/div/span').each do |d|
        diff = diff.concat(d)
      end
      dotIndexes = (0 ... diff.length).find_all { |i| diff[i, 1] == '.' }
      diff = diff[0..dotIndexes[0] + 2] + diff[(dotIndexes[0] + 7)..dotIndexes[1] + 2] + diff[(dotIndexes[1] + 7)..diff.length]
    rescue Exception => e  
      puts e.message
      return "error"
    end
    return composeReply(symbol, quote, diff)
  end

  def composeReply(symbol, quote, diff)
    return "#{Unicode::upcase(symbol)}: #{quote} #{diff}"
  end
end

Telegram::Bot::Client.run(ENV["TOKEN"]) do |bot|
  validator = Validator.new
  replyComposer = ReplyComposer.new
  stockWatcher = StockWatcher.new
  bot.listen do |message|
    unless message.nil? or message.text.nil? then
      text = message.text
      chatId = message.chat.id
      begin
        if (text.start_with?('/')) then
          atIndex = text.index('@')
          symbolEndIndex = atIndex.nil? ? text.length : atIndex - 1

          stockWatcher.getQuote(text[1..symbolEndIndex], bot, chatId)
        end

      validator.handleMessage(text, BOOBS, Proc.new { replyComposer.sendBoobs(bot, chatId) })
      validator.handleMessage(text, BUTTS, Proc.new { replyComposer.sendButts(bot, chatId) })
      validator.handleMessage(text, MANYAFILTER, Proc.new { replyComposer.replyManya(bot, message) })
      validator.handleMessage(text, VYNOSITE, Proc.new { replyComposer.sendEmergencyPicture(bot, chatId) })
    end
  end    
end
end