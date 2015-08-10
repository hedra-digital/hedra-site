class NotificationsMailerPreview
  def new_message
    NotificationsMailer.new_message message, publisher_id
  end
end
