module MoneytrackTest
  class Header
    attr_accessor  :timestamp, :previous_block, :payload_signature

    def initialize(timestamp = Time.now.utc.iso8601, previous_block, payload_signature)
      @timestamp = timestamp
      @previous_block = previous_block
      @payload_signature = payload_signature
    end

    def make_signature()
      payload = {
        :timestamp => @timestamp,
        :previous_block => @previous_block,
        :payload_signature => @payload_signature
      }
      Payload.new(payload).signature
    end

    def to_s()
      str = "\theader\n"
      str += "\t\ttimestamp = #{@timestamp}\n"
      str += "\t\trevious_block = #{@previous_block}\n"
      str += "\t\tpayload_signature = #{@payload_signature}\n"
      str
    end
  end
end
