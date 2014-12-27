require 'sonycam'
require 'twitter'
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "Qy7tXNJUWjQXu1iJgO0GA"
  config.consumer_secret     = "duROHPEPs2CftfXMhntLjBvI9BfUTUuIWkNw4VDWELQ"
  config.access_token        = "200783197-1n5EVZeoBQYmpxgyn3j7LUp5hXsVz0lRROHQtMGN"
  config.access_token_secret = "gqRG1V2Ec8hYxX9cXftmLEDFHieut7X3KeBvWkkU82juo"
end

api = Sonycam::API.new "http://10.0.0.1:10000/sony/camera"
image_url = api.request(:actTakePicture)[0][0]
client.update_with_media('I love Ruby Kaigi 2014 #rubykaigi #rubykaigib', open(image_url))