module MoneytrackTest
  class BlockChain
     attr_accessor :blockchain
     def initialize(blockChainJson)
       @blockchain =  blockChainJson.map { |blockJson|
          block = Block.new
          block.initialize_by_json(blockJson)
          block
       }
     end

     def create_new_block(payload)
       lastSignature = blockchain.last.signature
       newBlock = Block.new
       newBlock.create(payload, lastSignature)
     end
  end
end
