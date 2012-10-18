class Book < ActiveRecord::Base
  attr_accessible :description, :edition, :height, :name, :pages, :released_at, :weight, :width
end
