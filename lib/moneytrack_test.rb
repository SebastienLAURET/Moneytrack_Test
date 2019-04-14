require "msgpack"
require "digest"
require 'time'
require 'json'

require "moneytrack_test/version"

require_relative 'moneytrack_test/payload'
require_relative 'moneytrack_test/header'
require_relative 'moneytrack_test/block'
require_relative 'moneytrack_test/blockchain'
require_relative 'moneytrack_test/integrity_check_service'

module MoneytrackTest
  input = [
    {"hello"=>"world", "key1"=>"value1"},
    {"hello"=>"world", "key1"=>"value1", "key2"=>"value2"},
    {"hello"=>"world", "key2"=>"value2"},
    {"hello"=>"world", "key2"=>"value2", "another"=>"value"}
  ]

  blockchain = nil
  input.each { |newPayload|
    if blockchain.nil?
      blockchain = BlockChain.new(newPayload)
    else
      blockchain.create_new_block(newPayload)
    end
  }
  puts blockchain.to_hash

  begin
    IntegrityCheckService.new(blockchain.to_hash).perform
  rescue StandardError => e
    puts e.message
  end


  #
  # => test previous_block not found
  #

  test = [{:signature=>
   "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>nil,
    :payload_signature=>
     "3a87af5e8ceb519b74e02a2cfde90a12faa34f0f9142b033e5338acab58b18e5"},
  :payload=>{"hello"=>"world", "key1"=>"value1"}},
 {:signature=>
   "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>
     "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
    :payload_signature=>
     "7abc00bcc90ddce7c352c011b35760d2b1a5a0acd2abf856440090f3257c47bf"},
  :payload=>{"hello"=>"world", "key1"=>"value1", "key2"=>"value2"}},
 {:signature=>
   "4845bfd27ecc8e810a1145b4c90d0a66712ff139d68ebf1b2c55772f6d707783",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>
     "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
    :payload_signature=>
     "094ff398fcdca678695f9c909ee45fd9c6b0e34a465355943064b2beb6098c60"},
  :payload=>{"hello"=>"world", "key2"=>"value2", "another"=>"value"}}]

  begin
    IntegrityCheckService.new(test).perform
  rescue StandardError => e
    puts e.message
  end


  #
  # => test bad payload signature
  #

  test = [{:signature=>
   "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>nil,
    :payload_signature=>
     "3a87af5e8ceb519b74e02a2cfde90a12faa34f0f9142b033e5338acab58b18ed"},
  :payload=>{"hello"=>"world", "key1"=>"value1"}}
  ]

  begin
    IntegrityCheckService.new(test).perform
  rescue StandardError => e
    puts e.message
  end


  #
  # => test bad signature
  #

  test = [{:signature=>
   "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>nil,
    :payload_signature=>
     "3a87af5e8ceb519b74e02a2cfde90a12faa34f0f9142b033e5338acab58b18e5"},
  :payload=>{"hello"=>"world", "key1"=>"value1"}}
  ]

  begin
    IntegrityCheckService.new(test).perform
  rescue StandardError => e
    puts e.message
  end



  #
  # => test 2 stater block
  #

  test = [
   {:signature=>
     "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
    :header=>
     {:timestamp=>"2019-02-22T17:43:48Z",
      :previous_block=>
       "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
      :payload_signature=>
       "7abc00bcc90ddce7c352c011b35760d2b1a5a0acd2abf856440090f3257c47bf"},
    :payload=>{"hello"=>"world", "key1"=>"value1", "key2"=>"value2"}},
   {:signature=>
     "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
    :header=>
     {:timestamp=>"2019-02-22T17:43:48Z",
      :previous_block=>
       "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
      :payload_signature=>
       "efaaa9f4a61f715d691193b883edd83d84765234dbc3be8c456d93f8a4ec2293"},
    :payload=>{"hello"=>"world", "key2"=>"value2"}},
   {:signature=>
     "4845bfd27ecc8e810a1145b4c90d0a66712ff139d68ebf1b2c55772f6d707783",
    :header=>
     {:timestamp=>"2019-02-22T17:43:48Z",
      :previous_block=>
       "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
      :payload_signature=>
       "094ff398fcdca678695f9c909ee45fd9c6b0e34a465355943064b2beb6098c60"},
    :payload=>{"hello"=>"world", "key2"=>"value2", "another"=>"value"}}]

  begin
    IntegrityCheckService.new(test).perform
  rescue StandardError => e
    puts e.message
  end


#
# => test no stater block
#

  test = [
   {:signature=>
     "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
    :header=>
     {:timestamp=>"2019-02-22T17:43:48Z",
      :previous_block=>
       "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
      :payload_signature=>
       "7abc00bcc90ddce7c352c011b35760d2b1a5a0acd2abf856440090f3257c47bf"},
    :payload=>{"hello"=>"world", "key1"=>"value1", "key2"=>"value2"}},
   {:signature=>
     "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
    :header=>
     {:timestamp=>"2019-02-22T17:43:48Z",
      :previous_block=>
       "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
      :payload_signature=>
       "efaaa9f4a61f715d691193b883edd83d84765234dbc3be8c456d93f8a4ec2293"},
    :payload=>{"hello"=>"world", "key2"=>"value2"}},
   {:signature=>
     "4845bfd27ecc8e810a1145b4c90d0a66712ff139d68ebf1b2c55772f6d707783",
    :header=>
     {:timestamp=>"2019-02-22T17:43:48Z",
      :previous_block=>
       "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
      :payload_signature=>
       "094ff398fcdca678695f9c909ee45fd9c6b0e34a465355943064b2beb6098c60"},
    :payload=>{"hello"=>"world", "key2"=>"value2", "another"=>"value"}}]

  begin
    IntegrityCheckService.new(test).perform
  rescue StandardError => e
    puts e.message
  end
  exit()
end
