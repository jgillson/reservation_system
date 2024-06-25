# This is a controller class for Appointments in the V1 module of the API.
# It handles the reservation and confirmation of appointments.
# All methods in this class are actions applied to Appointment objects in the application.
#
# Actions in this controller:
# - reserve: Can be used to reserve a time slot for a client.
# - confirm: Can be used to confirm a previously reserved slot.
#
# It uses before_action to find resources related to the client, provider, and slot.
# Result of actions are handled by render_result private method, giving corresponding responses.
class Api::V1::AppointmentsController < ApplicationController
  before_action :find_resources, only: %i[reserve confirm]

  # Reserves a slot for an appointment
  # @result holds the result of the attempt to reserve a slot.
  def reserve
    @result = AppointmentService.new(@slot, @client, :reserve).perform
    render_result("Slot has been successfully reserved.")
  end

  # Confirms a reserved slot
  # @result holds the result of the attempt to confirm a slot reservation.
  def confirm
    @result = AppointmentService.new(@slot, @client, :confirm).perform
    render_result("Appointment has been confirmed successfully.")
  end

  private

  # Finds the necessary resources (client, provider & slot) for the appointment operations
  def find_resources
    @client = Client.find(params.require(:client_id).to_i)
    @provider = Provider.find(params.require(:provider_id).to_i)
    @slot = Slot.find(params.require(:appointment_id).to_i)
  end

  # Handles the response based on the result of an action
  # Provides a successful message or an error based on the the outcome.
  def render_result(message)
    if @result.present?
      if @result.respond_to?(:errors)
        render json: { error: @result.errors }, status: :unprocessable_entity
      else
        render json: { message: message }, status: :ok
      end
    else
      render json: { error: 'Unexpected error' }, status: :unprocessable_entity
    end
  end
end
