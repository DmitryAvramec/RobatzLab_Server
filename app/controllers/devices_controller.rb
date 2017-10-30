class DevicesController < ApplicationController
  protect_from_forgery with: :null_session

  # GET /devices
  # GET /devices.json
  def index
    @devices =Device.where("last_message_time >= TIMESTAMP WITH TIME ZONE '#{Time.zone.now - 120}'")
    respond_to do |format|
      format.html
      format.js
    end
  end

  def action
    device = Device.find_or_create_by(device_id: params[:device_id])
    if device.device_ip
      unless device.device_ip == request.remote_ip
        device.message = "Error! Same id for 2 or more devices! Last good ip was #{device.device_ip}"
      else
        device.email = params[:email] unless device.email == params[:email]
        device.last_message_time = Time.now
        device.message = params[:message] unless device.message == params[:message]
      end
    else
      device.device_ip = request.remote_ip
      device.message = params[:message]
      device.email = params[:email]
      device.last_message_time = Time.zone.now
    end
    device.save
    render json: { "status": 200, "message": "I take it! All is ok" }
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:device_id, :email, :message, :last_message_time)
    end
end
