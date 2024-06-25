require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:reservation) { create(:reservation) }

  context 'associations' do
    it 'belongs to client' do
      association = described_class.reflect_on_association(:client)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to slot' do
      association = described_class.reflect_on_association(:slot)
      expect(association.macro).to eq :belongs_to
    end
  end

  context 'validations' do
    it "is valid with valid attributes" do
      expect(reservation).to be_valid
    end
  end
end
