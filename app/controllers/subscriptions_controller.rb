class SubscriptionsController < ApplicationController
  def index
    @boxing = Subscription.find(:all, :params => {:sport => "Boxing", :user => "fred" })
    @running = Subscription.find(:all, :params => {:sport => "Running", :user => "fred" })
  end
end
