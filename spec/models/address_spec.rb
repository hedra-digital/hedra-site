require 'rails_helper'

RSpec.describe Address, :type => :model do
  describe ".address_line1" do
    let(:init_params) do
      {
        address: "fake address",
        number: 45
      }
    end

    subject { described_class.new(init_params) }

    it "combine address and number attributes" do
      expect(subject.address_line1).to eq("fake address, 45")
    end
  end
end
