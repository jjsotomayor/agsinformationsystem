class ReportsController < ApplicationController
  def index

    @humidity_samples = HumiditySample.all
    @last_week_samples = @humidity_samples.where('created_at > ?', DateTime.now - 7.days)

  end
end
