json.extract! device, :id, :device_id, :email, :message, :created_at, :updated_at
json.url device_url(device, format: :json)
