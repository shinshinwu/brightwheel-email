Rails.application.routes.draw do

  post "email" => "application#send_email"
end
