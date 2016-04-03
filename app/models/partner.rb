class Partner < ActiveRecord::Base
  attr_accessible :name, :email, :comission
  has_many :promotions

  def self.list
    self.all.map{|p| 
      [ p.email.present? ? "#{p.name.titleize} - #{p.email}" : p.name.titleize, p.id ]
    }
  end
end
