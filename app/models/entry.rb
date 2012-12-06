require 'active_resource'


class EntryXMLFormatter
  include ActiveResource::Formats::XmlFormat

  def decode(xml)
    puts "myxml : #{xml}"
    ActiveResource::Formats::XmlFormat.decode(xml)
  end
end


class Entry < ActiveResource::Base
  class << self
    def element_path(id, prefix_options = {}, query_options = nil)
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
    end

    def collection_path(prefix_options = {}, query_options = nil)
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{query_string(query_options)}"
    end

    def instantiate_collection(collection, prefix_options = {})
      puts "test===> #{collection}"
      #puts "====== entry name == #{element_name}"
      collection = collection[element_name] if collection.instance_of?(Hash)
      collection.collect! { |record| instantiate_record(record, prefix_options) }

    end

    def create
      run_callbacks :create do
        connection.put(collection_path, encode, self.class.headers).tap do |response|
          self.id = id_from_response(response)
          load_attributes_from_response(response)
        end
      end
    end
  end

  self.site = "http://diufvm31.unifr.ch:8090/CyberCoachServer/resources/users/:user/:sport/:entry_id"

  self.element_name = "entryboxing"

  self.format = EntryXMLFormatter.new





  schema do
    string 'name', 'description', 'id', 'entryrunning'
  end


end




