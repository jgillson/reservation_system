# This is a controller class for Schedules in the V1 module of the API.
# It handles the retrieval, creation, and validation of schedule slots for a specific provider.
#
# The before_action filter finds and validates the provider and slot details before creating a schedule.
#
# Actions in this controller:
# - index: lists all the open and editable slots for a specific provider.
# - create: creates new slots for a provider within the provided time range if it's valid.
class Api::V1::SchedulesController < ApplicationController
  before_action :find_and_validate_provider_and_slots, only: :create

  # List all available and editable slots for a specific provider
  def index
    slots = Slot.where(
      provider_id: provider_id,
      reserved: false,
      editable: true,
      )

    render json: slots
  end

  # Creates new slots for a specific provider within a given time range
  def create
    slots = @slot_service.make_slots(start_at, end_at, @provider)

    render json: slots, status: :ok
  end

  private

  # Finds the provider and validates the incoming slot details.
  # If the slot details are not valid, it renders an error message along with a 'bad_request' status.
  def find_and_validate_provider_and_slots
    find_provider_and_initialize_services
    unless @time_slot_validator.is_valid?(start_at, end_at, @provider)
      render json: @time_slot_validator.error, status: :bad_request and nil
    end
  end

  # Finds the provider with given 'provider_id' and initializes the SlotValidator and SlotService services.
  def find_provider_and_initialize_services
    @provider = Provider.find_by!(id: provider_id)
    @time_slot_validator = SlotValidator.new
    @slot_service = SlotService.new
  end

  # Extracts the 'provider_id' parameter and converts it to an integer
  def provider_id
    params.require(:provider_id).to_i
  end

  # Extracts the 'start_at' parameter
  def start_at
    params.require(:start_at)
  end

  # Extracts the 'end_at' parameter
  def end_at
    params.require(:end_at)
  end
end
