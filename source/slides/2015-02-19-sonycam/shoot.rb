require 'sonycam'
api = Sonycam::API.new "http://10.0.0.1:10000/sony/camera"
image_url = api.request(:actTakePicture)[0][0]
`wget #{image_url} -O ~/Desktop/#{Time.now.to_i}.jpg`