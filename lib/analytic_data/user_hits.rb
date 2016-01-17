class AnalyticData::UserHits
  attr_reader :user_id
  ACCESS_LIMIT = 15

  def initialize user_id
    @user_id = user_id
  end

  def add_hit
    $redis.zincrby "stats/total", 1, user_id
    $redis.zincrby "stats/#{ServerTime.now.to_date.to_s(:number)}", 1, user_id
  end

  def hits day = ServerTime.now.to_date
    $redis.zscore "stats/#{day.to_s(:number)}", user_id
  end

  def total_hits
    $redis.zscore "stats/total", user_id
  end

  def total_hits_today
    date = ServerTime.now.to_date.to_s :number
    $redis.zscore "stats/#{date}", user_id
  end

  def over_limit?
    hits > ACCESS_LIMIT
  end

  def stats_for_period begin_p, end_p
    begin_date = Date.parse begin_p
    end_date = Date.parse end_p
    ::AnalyticData::GetTop.new.keys(begin_date, end_date){|d|
      $redis.zscore("stats/#{d}", user_id).to_i}
  end
end
