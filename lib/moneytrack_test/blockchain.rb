module MoneytrackTest
  class BlockChain
     attr_accessor :blockchain
     def initialize(blockchainJson)
       blockchainTmp =  blockchainJson.map { |blockJson|
          block = Block.new
          block.initialize_by_json(blockJson)
          block
       }

       @blockchain = self.sort_blockchain(blockchainTmp)

       check_timestamp()
     end

     def sort_blockchain(blockchainTmp, hash = nil)
       elem = blockchainTmp.detect { |block| hash == block.header.previous_block }
       blockchainTmp.delete_if { |block| hash == block.header.previous_block }
       if elem == nil
         puts "ERROR: bockchain corrupted : block not found"
         exit()
       end
       tab_block = []
       tab_block = sort_blockchain(blockchainTmp, hash = elem.signature) unless blockchainTmp.empty?
       return [elem] + tab_block
     end

     def check_timestamp()
       prevTime = Time.parse(@blockchain.first.header.timestamp)
       @blockchain.each { |block|
         timestamp = Time.parse(block.header.timestamp)
         if prevTime > timestamp
           puts "ERROR: bockchain corrupted : timestamp not correct"
           exit()
         else
           prevTime = timestamp
         end
       }
     end

     def create_new_block(payload)
       lastSignature = blockchain.last.signature
       newBlock = Block.new
       newBlock.create(payload, lastSignature)
     end

     def to_s()
       str = "BlockChain\n"
       @blockchain.each { |block|  str += block.to_s }
       str
     end

  end
end
