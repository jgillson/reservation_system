require 'rails_helper'

RSpec.describe AppointmentService, type: :service do
  let(:slot) { create(:slot, editable: true, reserved: false) }
  let(:client) { create(:client) }

  describe '#perform' do
    context 'when the action is :reserve' do
      subject(:service) { described_class.new(slot, client, :reserve) }

      context 'when the slot is successfully reserved' do
        it 'updates the slot and creates a reservation' do
          result = service.perform

          expect(result.success?).to be true
          expect(slot.reload.reserved).to be true
          expect(slot.reserved_at).not_to be nil
          expect(result.result.reservation.slot).to eq slot
          expect(result.result.reservation.client).to eq client
        end
      end

      context 'when the slot is not editable' do
        before do
          slot.update(editable: false)
        end

        it 'raises an error' do
          result = service.perform

          expect(result.success?).to be false
          expect(result.errors).to eq('Slot is not modifiable.')
        end
      end
    end
  end
end
