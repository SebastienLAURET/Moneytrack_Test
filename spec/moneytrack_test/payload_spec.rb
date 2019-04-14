require "spec_helper"

RSpec.describe Payload do
  context "make the payload signature" do
    let(:data) { {
    "hello" => "world",
    "key" => "value"
    } }

    it "signature" do
        payload = Payload.new data
        expect(payload.signature).to eq "ca9edf6b92aa42a4e90f8d13f114936cf64156d1d54e00af931ae5e7a24cae28"
    end
  end
end
