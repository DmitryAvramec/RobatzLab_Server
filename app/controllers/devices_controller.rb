class DevicesController < ApplicationController
  protect_from_forgery with: :null_session

  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.where("last_message_time >= ?", Time.now - 120)
  end

  def action
    binding.pry
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
      device.last_message_time = Time.now
    end
    binding.pry
    device.save
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:device_id, :email, :message, :last_message_time)
    end
end
