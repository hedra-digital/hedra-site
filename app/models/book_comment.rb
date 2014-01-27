# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: comments
#
#  id         	:integer          not null, primary key
#  content    	:string(255) 	  not null
#  author     	:string(255)
#  vehicle    	:string(255)
#  commented_at :date
#  created_at 	:datetime         not null
#  updated_at 	:datetime         not null
#  book_id    	:integer
#

class BookComment < ActiveRecord::Base
  # Relationships
  belongs_to        :book

  # Specify fields that can be accessible through mass assignment
  attr_accessible :content, :author, :vehicle, :commented_at, :book_id
end