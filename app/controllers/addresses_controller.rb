# -*- encoding : utf-8 -*-
class AddressesController < ApplicationController

  def create
    @address = Address.create(params[:address])
    respond_to do |format|
      format.js
    end
  end

  def get_address
  	@address = Address.find_by_id(params[:id])
    respond_to do |format|
      format.json { render json: @address }
    end
  end
end
