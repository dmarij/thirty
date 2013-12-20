class HomeController < ApplicationController
  def index
  	delete_new_challenge_refferer
  	my_store_location
    @challenges = Challenge.where(final_state: 'active').paginate(:page => params[:page], :per_page => 5)
  end
end
