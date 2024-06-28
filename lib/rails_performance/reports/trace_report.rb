module RailsPerformance
  module Reports
    class TraceReport
      attr_reader :request_id

      def initialize(request_id:)
        @request_id = request_id
      end

      def data
        begin
          key   = "trace|#{request_id}|END|#{RailsPerformance::SCHEMA}"
          JSON.parse(RailsPerformance.redis.get(key).presence || '[]')
        rescue => error
          RailsPerformance.log "\n\n [REDIS CONNECTION NOT FOUND]"
          return [] 
        end
      end
    end


  end
end