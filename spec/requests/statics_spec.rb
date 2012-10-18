require 'spec_helper'

describe "Statics" do
  describe "Home page" do
    it "Should have content CyberCoach" do
      visit '/static/home'
      page.should have_content('CyberCoach')
    end
  end
end
