class BoxingController < ApplicationController
  def index
    @boxing = Boxing.find(:all, :params => { :user_id => "fred" })
  end
end
