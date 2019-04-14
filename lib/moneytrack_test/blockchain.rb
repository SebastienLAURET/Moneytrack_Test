module MoneytrackTest
  class BlockChain
     attr_accessor :blockchain

     def initialize(payload)
       @blockchain = []
       create_new_block(payload)
     end

     def create_new_block(payload)
       lastSignature = blockchain.last&.signature
       newBlock = Block.new
       newBlock.create(payload, lastSignature)
       @blockchain += [newBlock]
     end

     def to_hash
       blockchain.map { |block| block.to_hash }
     end
  end
end
