class NotesController < ApplicationController
  load_and_authorize_resource :except => [:new, :create]
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /notes
  # GET /notes.json
  def index
    delete_new_challenge_refferer
    my_store_location
    delete_note_refferer
    note_store_location
    notes_order = current_user.notes_order
    @q = current_user.notes.search(params[:q])
    @q.sorts = "id #{notes_order}"
    @notes = @q.result.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id

    respond_to do |format|
      if @note.save
        format.html { note_redirect_back_or notes_path, 'Note was successfully created.' }
        format.json { render action: 'show', status: :created, location: @note }
      else
        format.html { render action: 'new' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { note_redirect_back_or notes_path, 'Note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { note_redirect_back_or notes_url, 'Note was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def reorder
    if current_user.notes_order == 'desc'
      current_user.update_attribute(:notes_order, 'asc')
    else
      current_user.update_attribute(:notes_order, 'desc')
    end
    redirect_to notes_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:body, :challenge_id)
    end
end
