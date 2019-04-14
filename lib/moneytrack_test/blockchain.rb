module MoneytrackTest
  class BlockChain
     attr_accessor :blockchain

     def initialize(payload)
       @blockchain = []
       create_new_block(payload)
     end

     def sort_blockchain(blockchainTmp, hash = nil)
       elem = blockchainTmp.detect { |block| hash == block.header.previous_block }
       blockchainTmp.delete_if { |block| hash == block.header.previous_block }
       raise StandardError.new("ERROR: bockchain corrupted : block not found") if elem == nil
       tmp = []
       tmp += sort_blockchain(blockchainTmp, hash = elem.signature) unless blockchainTmp.empty?
       return [elem] + tmp
     end

     def check_timestamp()
       prevTime = Time.parse(@blockchain.first.header.timestamp)
       @blockchain.each { |block|
         timestamp = Time.parse(block.header.timestamp)
         raise StandardError.new("ERROR: bockchain corrupted : timestamp not correct") if prevTime > timestamp
         prevTime = timestamp
       }
     end

     def create_new_block(payload)
       lastSignature = blockchain.last&.signature
       newBlock = Block.new
       newBlock.create(payload, lastSignature)
       @blockchain += [newBlock]
     end

     def to_s()
       str = "BlockChain\n"
       @blockchain.each { |block|  str += block.to_s }
       str
     end
  end
end
