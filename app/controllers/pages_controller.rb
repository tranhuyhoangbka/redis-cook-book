class PagesController < ApplicationController
  TIME_FORMAT = "%Y-%m-%d"
  LIMIT_DAYS = 10.days

  def home
  end

  def stats
    params[:end_date] ||= ServerTime.now.strftime TIME_FORMAT
    @top_users = if params[:start_date].present?
      AnalyticData::GetTop.new.top_for_period(params[:start_date],
        params[:end_date]).map{|u| [User.find_by_id(u[0]), u[1].to_i]}
    else
      AnalyticData::GetTop.new.top_users.map{|u| [User.find_by_id(u[0]),
      u[1].to_i]}
    end
    @data_ten_days_chart = ((ServerTime.now.to_date - LIMIT_DAYS)..ServerTime.now.to_date).map do |d|
      [d, AnalyticData::GetTop.new.sum_hit_for_day(d)]
    end
    @data_chart_top_users = @top_users.map{|u| [u[0].name, u[1]]}
    @total_hits = AnalyticData::GetTop.new.get_total
    logger.debug "============>#{@top_users}"
    respond_to do |format|
      format.html
      format.js
    end
  end
end
