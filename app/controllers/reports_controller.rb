class ReportsController < ApplicationController
  before_action :check_permissions

  def index

    @humidity_samples = HumiditySample.all
    @last_week_samples = @humidity_samples.where('created_at > ?', DateTime.now - 7.days)

  end

  def check_permissions
    return if can_access_all_report?
    redirect_to root_path, alert: not_allowed
  end

end
