require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:client) { create(:client) }

  context 'associations' do
    it 'has many reservations' do
      association = described_class.reflect_on_association(:reservations)
      expect(association.macro).to eq :has_many
    end
  end

  context 'validations' do
    it "is valid with valid attributes" do
      expect(client).to be_valid
    end
  end
end
