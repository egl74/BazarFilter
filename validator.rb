require 'unicode'

class Validator
  def handleMessage(message, keyWords, handler, removeRepetitiveSymbols = false)
    unless validateMessage(message, keyWords, removeRepetitiveSymbols)
      handler.call()
    end
  end

  def validateMessage(message, filterList, removeRepetitiveSymbols)
    filterList.each do |word|
      message = removeRepetitiveSymbols ? handleRepetitiveSymbols(message) : message
      if Unicode::downcase(message).include? word
	      return false
      end
    end
    return true
  end

  def handleRepetitiveSymbols(text)
    result = text.gsub(/(.*)\1+/, '\1')
    return result
  end
end