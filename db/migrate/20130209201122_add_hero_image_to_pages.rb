# -*- encoding : utf-8 -*-
class AddHeroImageToPages < ActiveRecord::Migration
  def change
    add_column :pages, :hero_image, :string
  end
end
