require 'rails_helper'

RSpec.describe Api::V1::AppointmentsController, type: :request do
  describe 'POST #reserve' do
    let(:client) { create(:client) }
    let(:provider) { create(:provider) }
    let(:slot) { create(:slot) }

    before do
      allow(AppointmentService).to receive(:new).and_return(service)
      post reserve_api_v1_appointments_path, params: { client_id: client.id, provider_id: provider.id, appointment_id: slot.id }
    end

    context 'when the reserve is successful' do
      let(:service) { double('AppointmentService', perform: true) }

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with success message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Slot has been successfully reserved.')
      end
    end

    context 'when the reserve fails' do
      let(:service) { double('AppointmentService', perform: nil, errors: 'error message') }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(422)
      end

      it 'responds with error' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq('Unexpected error')
      end
    end
  end

  describe 'POST #confirm' do
    let(:client) { create(:client) }
    let(:provider) { create(:provider) }
    let(:slot) { create(:slot) }

    before do
      allow(AppointmentService).to receive(:new).and_return(service)
      post confirm_api_v1_appointments_path, params: { client_id: client.id, provider_id: provider.id, appointment_id: slot.id }
    end

    context 'when the confirmation is successful' do
      let(:service) { double('AppointmentService', perform: true) }

      it 'returns http success' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with success message' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to eq('Appointment has been confirmed successfully.')
      end
    end

    context 'when the confirmation fails' do
      let(:service) { double('AppointmentService', perform: nil, errors: 'error message') }

      it 'returns unprocessable entity status' do
        expect(response).to have_http_status(422)
      end

      it 'responds with error' do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq('Unexpected error')
      end
    end
  end
end
