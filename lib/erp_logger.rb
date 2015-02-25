class ErpLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{msg}\n"
  end
end
 
logfile = File.open("#{Rails.root}/log/erp.log", 'a')  # create log file
logfile.sync = true  # automatically flushes data to file
ERP_LOGGER = ErpLogger.new(logfile)  # constant accessible anywhere