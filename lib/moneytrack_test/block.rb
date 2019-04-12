module MoneytrackTest
  class Block
     attr_accessor :signature, :header, :payload

     def initialize_by_json(block)
       @payload = Payload.new block[:payload]
       @header = Header.new block[:header][:timestamp], block[:header][:previous_block], block[:header][:payload_signature]
       @signature = block[:signature]
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
