RSpec.describe Payload do
  context "Creation first block" do
    let(:data) { {
    "hello" => "world",
    "key" => "value"
    } }

    it "signature" do
        payload = Payload.new data
        expect(payload.signature).to eq "ca9edf6b92aa42a4e90f8d13f114936cf64156d1d54e00af931ae5e7a24cae28"
    end
  end

  context "Creation a block" do
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
