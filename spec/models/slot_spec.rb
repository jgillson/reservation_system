require 'rails_helper'

RSpec.describe Slot, type: :model do
  let(:slot) { create(:slot) }

  context 'associations' do
    it 'belongs to provider' do
      association = described_class.reflect_on_association(:provider)
      expect(association.macro).to eq :belongs_to
    end

    it 'has one reservation' do
      association = described_class.reflect_on_association(:reservation)
      expect(association.macro).to eq :has_one
    end
  end

  context 'validations' do
    it "is valid with valid attributes" do
      expect(slot).to be_valid
    end
  end
end
