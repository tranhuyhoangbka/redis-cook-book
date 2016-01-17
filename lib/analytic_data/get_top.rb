class AnalyticData::GetTop
  def top_users period = "total", limit = 5
    $redis.zrevrange("stats/#{period}", 0, limit, withscores: true)
  end

  def top_for_period begin_d, end_d, limit = 5
    begin_date = Date.parse begin_d
    end_date = Date.parse end_d
    new_key = "top/#{begin_date.to_s(:number)}/#{end_date.to_s(:number)}"
    return $redis.zrevrange(new_key, 0, limit, withscores: true) if $redis.exists(new_key)
    $redis.multi do
      $redis.zunionstore new_key, keys(begin_date, end_date){|d| "stats/#{d}"}
      $redis.expire new_key, 10.minutes
      $redis.zrevrange new_key, 0, limit, withscores: true
    end.last
  end

  def keys begin_p, end_p
    keys = []
    while begin_p <= end_p
      keys << if block_given?
        yield begin_p.to_s(:number)
      else
        begin_p.to_s :number
      end
      begin_p += 1.day
    end
    keys
  end

  def get_total period = "total"
    $redis.zrange("stats/#{period}", 0, -1, withscores: true)
      .map{|e| e[1]}.sum.to_i
  end

  def sum_hit_for_day day
    $redis.zrange("stats/#{day.to_s(:number)}", 0, -1, withscores: true)
      .map{|u| u[1].to_i}.sum
  end
end
