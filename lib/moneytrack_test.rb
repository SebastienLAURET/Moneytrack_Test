require "msgpack"
require "digest"
require 'time'
require 'json'

require "moneytrack_test/version"

require_relative 'moneytrack_test/payload'
require_relative 'moneytrack_test/header'
require_relative 'moneytrack_test/block'
require_relative 'moneytrack_test/blockchain'

module MoneytrackTest
  blockchain = nil
  while (data = gets.chomp) != "exit"
#    begin
      newPayload = JSON.parse(data)
      if blockchain == nil
        blockchain = BlockChain.new(newPayload)
      else
        blockchain.create_new_block(newPayload)
      end
      puts blockchain
#    rescue StandardError => e
#      puts e.message
#    end
  end
end
