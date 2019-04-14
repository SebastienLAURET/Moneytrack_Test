module MoneytrackTest
  class Block
    attr_accessor :signature, :header, :payload

    def create(payload, previous_block)
      @payload = Payload.new payload
      @header = Header.new previous_block, @payload.signature
      @signature = @header.make_signature
    end

    def to_hash
      {
        :signature => @signature,
        :header => @header.to_hash,
        :payload => @payload.payload
      }
    end
  end
end
