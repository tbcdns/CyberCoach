class SubscriptionsController < ApplicationController
  def index

    @boxing= Entry.find(:all, :params => {:sport => "Soccer", :user => 'fred', :entry_id => 154})

    puts "boxing : #{@boxing}"
  end
end
