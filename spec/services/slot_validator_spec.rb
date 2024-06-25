require 'rails_helper'

RSpec.describe SlotValidator, type: :service do
  let(:provider) { create(:provider) }
  let(:start_at) { "2022-01-01T08:00:00".to_datetime }
  let(:end_at) { "2022-01-01T08:30:00".to_datetime }
  let(:subject) { described_class.new }

  describe '#is_valid?' do
    context 'when the time is not in 5 minute increments' do
      let(:start_at) { "2022-01-01T08:03:00".to_datetime }

      it 'is not valid' do
        expect(subject.is_valid?(start_at, end_at, provider)).to be_falsey
        expect(subject.error).to eq("Both the start and end time must be in 5 minute increments")
      end
    end

    context 'when the slot is less than minimum duration' do
      let(:end_at) { "2022-01-01T08:14:00".to_datetime }

      it 'is not valid' do
        expect(subject.is_valid?(start_at, end_at, provider)).to be_falsey
        expect(subject.error).to eq("Both the start and end time must be in 5 minute increments")
      end
    end

    context 'when the slot overlaps existing ones' do
      before do
        Slot.create(start_at: start_at, end_at: end_at, provider: provider)
      end

      it 'is not valid' do
        expect(subject.is_valid?(start_at, end_at, provider)).to be_falsey
        expect(subject.error).to eq("Overlaps with existing slot")
      end
    end

    context 'when the slot is valid' do
      it 'is valid' do
        expect(subject.is_valid?(start_at, end_at, provider)).to be_truthy
      end
    end
  end
end
