module RailsPerformance

  class Utils
    # date key in redis store
    def Utils.cache_key(now = Date.today)
      "date-#{now}"
    end

    # write to current slot
    # time - date -minute
    def Utils.field_key(now = Time.current)
      now.strftime("%H:%M")
    end

    def Utils.fetch_from_redis(query)
      RailsPerformance.log "\n\n   [REDIS QUERY]   -->   #{query}\n\n"

      begin 
        keys   = RailsPerformance.redis.keys(query)
        return [] if keys.blank?
        values = RailsPerformance.redis.mget(keys)
      rescue => error
        RailsPerformance.log "\n\n [REDIS CONNECTION NOT FOUND]"
        return [] 
      end

      RailsPerformance.log "\n\n   [FOUND]   -->   #{values.size}\n\n"

      [keys, values]
    end

    def Utils.save_to_redis(key, value, expire = RailsPerformance.duration.to_i)
      # TODO think here if add return
      #return if value.empty?

      RailsPerformance.log "  [SAVE]    key  --->  #{key}\n"
      RailsPerformance.log "  [SAVE]    value  --->  #{value.to_json}\n\n"
      begin
        RailsPerformance.redis.set(key, value.to_json, ex: expire.to_i)
      rescue => error
        RailsPerformance.log "\n\n [REDIS CONNECTION NOT FOUND]"
      end
    end

    def Utils.days
      (RailsPerformance.duration / 1.day) + 1
    end

    def Utils.median(array)
      sorted = array.sort
      size   = sorted.size
      center = size / 2

      if size == 0
        nil
      elsif size.even?
        (sorted[center - 1] + sorted[center]) / 2.0
      else
        sorted[center]
      end
    end
  end
end
