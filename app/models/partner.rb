class Partner < ActiveRecord::Base
  attr_accessible :name, :email, :comission, :notify
  has_many :promotions

  def self.list
    self.all.map{|p| 
      [ p.email.present? ? "#{p.name.titleize} - #{p.email}" : p.name.titleize, p.id ]
    }
  end

  def notify
    @notify
  end

  def notify=(value)
    @notify = value
  end
end