class SubscriptionsController < ApplicationController
  def index

    @boxing= Boxing.find(:all, :params => {:sport => "Boxing", :user => 'fred', :entry_id => 142})

    puts "boxing : #{@boxing}"
  end
end
