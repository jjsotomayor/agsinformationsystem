module SamplesMethods

  def set_success_message_variables
    @edited_sample = false
    @created_sample = false
    if @created_sample = params[:created_sample]
      @created_sample = params[:created_sample]
      @sample_state = params[:state]
    elsif @edited_sample = params[:edited_sample]
      @edited_sample = true
      @sample_state = params[:state]
    end
  end

end
