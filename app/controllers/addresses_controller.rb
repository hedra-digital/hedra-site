# -*- encoding : utf-8 -*-
class AddressesController < ApplicationController 

  def create
    address = Address.create(params[:address])
    session[:address_id] = address.id

    if address.default? #new address default, make others not default
      Address.change_user_default(current_user.id, address.id)
    end

    respond_to do |format|
      format.js
    end
  end

  def get_address
  	address = Address.find_by_id(params[:id])

    session[:address_id] = address.id

    respond_to do |format|
      format.json { render json: address }
    end
  end

  def get_chosen_address_id
    id = session[:address_id]

    respond_to do |format|
      format.json { render json: id }
    end
  end
end
