require "msgpack"
require "digest"

require "moneytrack_test/version"

require_relative 'moneytrack_test/payload'
require_relative 'moneytrack_test/payload_manager'

module MoneytrackTest
  test = PayloadManager.new(PAYLOAD)
  puts test.signature
end
