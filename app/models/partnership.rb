require 'active_resource'

class Partnership < ActiveResource::Base
  class << self
    def element_path(id, prefix_options = {}, query_options = nil)
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
    end

    def collection_path(prefix_options = {}, query_options = nil)
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
    end

    def instantiate_collection(collection, prefix_options = {})
                    puts "tttt #{collection}"
      collection = collection["partnerships"] if collection.instance_of?(Hash)
      if !collection.nil?
        collection.collect! { |record| instantiate_record(record, prefix_options) }
      end
    end




  end

  self.site = "http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/partnerships/:user1;:user2"
  self.element_name =  ""

  schema do
    string 'name', 'description', 'id'
  end


end

