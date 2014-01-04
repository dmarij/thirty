module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def my_redirect_back_or(default)
    redirect_to(session[:return_to_aft_chall] || default, notice: 'Challenge was successfully created.')
  end

  def delete_new_challenge_refferer
    session.delete(:return_to_aft_chall)
  end

  def my_store_location
    session[:return_to_aft_chall] = request.url if request.get?
  end

  def note_redirect_back_or(default, notice)
    redirect_to(session[:return_to_aft_note] || default, notice: notice)
  end

  def delete_note_refferer
    session.delete(:return_to_aft_note)
  end

  def note_store_location
    session[:return_to_aft_note] = request.url if request.get?
  end

  

end
