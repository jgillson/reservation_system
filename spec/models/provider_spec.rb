require 'rails_helper'

RSpec.describe Provider, type: :model do
  let(:provider) { create(:provider) }

  context 'associations' do
    it 'has many slots' do
      association = described_class.reflect_on_association(:slots)
      expect(association.macro).to eq :has_many
    end
  end

  context 'validations' do
    it "is valid with valid attributes" do
      expect(provider).to be_valid
    end
  end
end
