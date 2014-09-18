class PostTrackingController < ApplicationController

  def index
    	@locations = ActiveSupport::JSON.decode(open("http://developers.agenciaideias.com.br/correios/rastreamento/json/#{params[:id]}"))
  	rescue
      redirect_to "/", :notice => "código postal não existe."
  end
  
end
