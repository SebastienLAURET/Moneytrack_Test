module MoneytrackTest
  class PayloadManager
     attr_accessor :payload, :serialized, :signature

     def initialize(payload)
       @payload = payload
       self.make_signature!
     end

     def make_signature!()
       serialize!()
       sign!()
     end

     def serialize()
       @payload.to_msgpack
     end

     def serialize!()
       @serialized = self.serialize
     end

     def sign()
        Digest::SHA256.hexdigest(@serialized)
     end

     def sign!()
       @signature = self.sign
     end
  end
end
