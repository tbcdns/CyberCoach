require 'rest-client'
class User_rest < RestClient::Resource
  resource = RestClient::Resource.new 'http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/'
  response = Crack::XML.parse(resource)
  # To change this template use File | Settings | File Templates.
end