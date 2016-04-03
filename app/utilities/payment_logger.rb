class PaymentLogger 
  
  def initialize
    @@logger ||= Logger.new("#{Rails.root}/log/payment_error.log")
  end

  class << self

	  def log(msg = '')
	  	self.new
	  	@@logger.info self.template msg
	  end

	  def template(msg)
	  	content =  fill_with_hash_delimiter
	  	content << break_line
	  	content << msg
	  	content << break_line
	    content << fill_with_under_delimiter
	    content << break_line
	    content << caller.join("\n")
	    content << break_line
	    content << fill_with_hash_delimiter
	  end

	  private 
	  def break_line
	  	"\n"
	  end

	  def fill_with_hash_delimiter
	  	return "#" * 110
	  end

	  def fill_with_under_delimiter
	  	return "_" * 110
	  end
	end
end