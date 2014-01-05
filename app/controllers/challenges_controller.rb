class ChallengesController < ApplicationController
  load_and_authorize_resource :except => [:new, :create]
  before_filter :authenticate_user!
  before_action :set_challenge, only: [:show, :edit, :update, :destroy, :give_up, :done, :reactivate, :repeat, :reorder_notes]
  # GET /challenges
  # GET /challenges.json
  def index
    delete_new_challenge_refferer
    my_store_location
    @q = current_user.challenges.search(params[:q])
    @challenges = @q.result.paginate(:page => params[:page], :per_page => 14)
  end

  # GET /challenges/1
  # GET /challenges/1.json
  def show
    delete_note_refferer
    note_store_location
    notes_order = current_user.notes_order_inline
    @notes = @challenge.notes.order("id #{notes_order}").paginate(:page => params[:page], :per_page => 5)
    @note = @challenge.notes.build
  end

  # GET /challenges/new
  def new
    @challenge = Challenge.new
    @challenge.duration = 30
  end

  # GET /challenges/1/edit
  def edit
  end

  # POST /challenges
  # POST /challenges.json
  def create
    @challenge = Challenge.new(challenge_params)
    @challenge.final_state = 'active'
    @challenge.user_id = current_user.id

    respond_to do |format|
      if @challenge.save
        format.html { my_redirect_back_or @challenge }
        format.json { render action: 'show', status: :created, location: @challenge }

      else
        format.html { render action: 'new' }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /challenges/1
  # PATCH/PUT /challenges/1.json
  def update
    respond_to do |format|
      if @challenge.update(challenge_params)
        format.html { redirect_to @challenge, notice: 'Challenge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /challenges/1
  # DELETE /challenges/1.json
  def destroy
    @challenge.destroy
    respond_to do |format|
      format.html { redirect_to challenges_url, notice: 'Challenge was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def give_up
    @challenge.update_attribute(:final_state, 'failed')
    redirect_to @challenge, notice: 'Challenge was marked as failed.'
  end

  def done
    @challenge.update_attribute(:final_state, 'done')
    redirect_to @challenge, notice: 'Challenge was marked as done.'
  end

  def reactivate
    @challenge.update_attribute(:final_state, 'active')
    redirect_to @challenge, notice: 'Challenge is active again.'
  end

  def repeat
    @new_challenge = Challenge.new()
    @new_challenge.title = @challenge.title
    @new_challenge.duration = @challenge.duration
    @new_challenge.description = @challenge.description
    @new_challenge.user_id = @challenge.user_id
    @new_challenge.final_state = 'active'
    @new_challenge.save
    redirect_to @new_challenge, notice: 'Challenge was successfully cloned and started again.'
  end

  def reorder_notes
    if current_user.notes_order_inline == 'desc'
      current_user.update_attribute(:notes_order_inline, 'asc')
    else
      current_user.update_attribute(:notes_order_inline, 'desc')
    end
    redirect_to @challenge
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_challenge
      @challenge = Challenge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def challenge_params
      params.require(:challenge).permit(:title, :duration, :description)
    end
end
