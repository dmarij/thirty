class HomeController < ApplicationController
  def index
  	delete_new_challenge_refferer
  	my_store_location
    @challenges = current_user.challenges.where(final_state: 'active').paginate(:page => params[:page], :per_page => 5) if user_signed_in?
  	@challenges_all = current_user.challenges if user_signed_in?
  end
end
