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
       if @signature != @header.make_signature
         puts "ERROR: bockchain corrupt: header signature not correct"
         exit();
       end
       if @header.payload_signature != @payload.sign
         puts "ERROR: bockchain corrupt: Payload signature not correct"
         exit();
       end
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
