require 'rails_helper'

RSpec.describe SlotService, type: :service do
  let(:provider) { create(:provider) }
  let(:start_at) { "2022-01-01T08:00:00".to_datetime }
  let(:end_at) { "2022-01-01T08:55:00".to_datetime }
  let(:subject) { described_class.new }

  describe '#make_slots' do
    context 'when given a range of times' do
      it 'creates slots every 15 minutes' do
        expect { subject.make_slots(start_at, end_at, provider) }.to change { Slot.count }.by(9)

        expect(Slot.first.start_at).to eq(start_at)
        expect(Slot.first.end_at).to eq(start_at + 15.minutes)
        expect(Slot.last.start_at).to eq(start_at + 40.minutes)
        expect(Slot.last.end_at).to eq(start_at + 55.minutes)

        Slot.all.each do |slot|
          expect(slot.provider_id).to eq(provider.id)
        end
      end
    end
  end
end
