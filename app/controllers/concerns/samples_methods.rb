module SamplesMethods

  private
  def set_success_message_variables
    @edited_sample = false
    @created_sample = false
    if @created_sample = params[:created_sample]
      @created_sample = params[:created_sample]
      @sample_state = params[:status]
    elsif @edited_sample = params[:edited_sample]
      @edited_sample = true
      @sample_state = params[:status]
    end
  end

  def element_params
    params.permit(:tag)
  end

end
