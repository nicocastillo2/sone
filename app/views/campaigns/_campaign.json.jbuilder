json.extract! campaign, :id, :name, :sender_name, :sender_email, :logo, :color, :created_at, :updated_at
json.url campaign_url(campaign, format: :json)
