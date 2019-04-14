module MoneytrackTest
  class Payload
     attr_accessor :payload, :serialized, :signature

     def initialize(payload)
       @payload = payload
       self.sign!
     end

     def sign()
        Digest::SHA256.hexdigest(@payload.to_msgpack)
     end

     def sign!()
       @signature = self.sign
     end
  end
end
