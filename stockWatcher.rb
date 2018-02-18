require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'unicode'

class StockWatcher
  def getQuote(text)
    atIndex = text.index('@')
    symbolEndIndex = atIndex.nil? ? text.length : atIndex - 1
    return fetchQuote(text[1..symbolEndIndex])
  end

  def fetchQuote(symbol)
    quote = ""
    diff = ""
    url = "https://www.investing.com/currencies/#{symbol}-usd"
    begin
      doc = Nokogiri::HTML(open(url))
      sleep(1)
      doc.xpath('//*[@id="last_last"]/text()').each do |q|
        quote = "#{q}$"
      end
      doc.xpath('//*[@id="quotes_summary_current_data"]/div[1]/div[2]/div[1]/span[2]').each do |d|
        diff = diff.concat(d)
      end
      diff.concat(' ')
      doc.xpath('//*[@id="quotes_summary_current_data"]/div[1]/div[2]/div[1]/span[4]').each do |d|
        diff = diff.concat(d)
      end
    rescue Exception => e  
      puts e.message
      return "error"
    end
    return composeReply(symbol, quote, diff)
  end

  def composeReply(symbol, quote, diff)
    return "#{Unicode::upcase(symbol)}: `#{quote}` #{diff}"
  end
end