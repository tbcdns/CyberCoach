require 'extensions/custom_format'

ActionController::Base.class_eval do
  include ActiveResource::Formats::CustomFormat
end

