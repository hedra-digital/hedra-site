# -*- encoding : utf-8 -*-
class AddressesController < ApplicationController

  def create
    @address = Address.create(params[:address])
    respond_to do |format|
      format.js
    end
  end

end
