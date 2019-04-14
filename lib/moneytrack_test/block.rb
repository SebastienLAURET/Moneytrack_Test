module MoneytrackTest
  class Block
     attr_accessor :signature, :header, :payload

     def initialize_by_json(block)
       @payload = Payload.new block[:payload]
       @header = Header.new block[:header][:timestamp], block[:header][:previous_block], block[:header][:payload_signature]
       @signature = block[:signature]
       check_block
     end

     def check_block
      raise StandardError.new("ERROR: bockchain corrupt: header signature not correct") if @signature != @header.make_signature
      raise StandardError.new("ERROR: bockchain corrupt: Payload signature not correct") if @header.payload_signature != @payload.sign
     end

     def create(payload, previous_block)
       @payload = Payload.new payload
       @header = Header.new previous_block, @payload.signature
       @signature = @header.make_signature
     end


      def to_s()
        str = "Block : #{signature}\n"
        str += @header.to_s
        str += @payload.to_s
        str
      end
  end
end
