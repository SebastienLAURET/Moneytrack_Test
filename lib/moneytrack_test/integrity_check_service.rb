module MoneytrackTest
  class IntegrityCheckService
    attr_accessor :blockchain

    def initialize(blockchain)
      @blockchain = blockchain
    end

    def perform
      blockchain_hash = change_struct()
      make_check(blockchain_hash)
    end

    def change_struct
      blockchain_hash = {}
      @blockchain.each { |block|
        blockchain_hash[block[:signature]] = block
      }
      blockchain_hash
    end

    def make_check(blockchain_hash)
      nb_first_block = 0
      @blockchain.each { |block|
        check_playload_signature(block)
        check_previous_block(block, blockchain_hash)
        check_signature(block)
        nb_first_block +=  check_nb_first_block(block)
      }
      raise StandardError.new("Error: starter block not found") if nb_first_block == 0
      raise StandardError.new("Error: found many starter block") if nb_first_block > 1
    end

    def check_nb_first_block(block)
      if block[:header][:previous_block].nil?
        1
      else
        0
      end
    end

    def check_playload_signature(block)
      unless block[:header][:payload_signature] == sign(block[:payload])
        raise StandardError.new("Error: bad payload signature [block  :: #{block[:signature]}]")
      end
    end

    def check_previous_block(block ,blockchain_hash)
      if !block[:header][:previous_block].nil? && !blockchain_hash[block[:previous_block]].nil?
        raise StandardError.new("Error: previous block not found [block  :: #{block[:signature]}]")
      end
    end

    def check_signature(block)
      unless block[:signature] == sign(block[:header])
        raise StandardError.new("Error: bad block signature [block  :: #{block[:signature]}]")
      end
    end

    def sign(data)
      Digest::SHA256.hexdigest(data.to_msgpack)
    end
  end
end
