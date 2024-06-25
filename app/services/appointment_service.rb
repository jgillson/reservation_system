# The AppointmentService class is a service object that encapsulates the business logic
# required for managing slots and their reservations.
#
# This service object can handle different actions including :reserve and :confirm,
# each action is triggered in the perform method based on the provided operation
# type at the time of initialisation.
#
# The service object takes a slot, a client, and an action as initialization arguments.
#
# It contains methods for reserving a slot and, separately, for confirming a slot reservation.
# Each of these methods contains several assertions to ensure that the slot is in the correct state
# before the action is performed.
#
# Reservation and confirmation operations return an OpenStruct which includes
# a :success? flag indicating whether the operation was successful, along with
# the result or any error messages.
class AppointmentService
  # AppointmentService initializer
  # Params: Slot object, Client object and :reserve / :confirm action
  def initialize(slot, client, action)
    @slot = slot
    @client = client
    @action = action
  end

  # Performs the specified action on the slot
  def perform
    result = case @action
             when :reserve then reserve_slot
             when :confirm then confirm_slot
             end
    OpenStruct.new(success?: true, result: result)
  rescue StandardError => e
    OpenStruct.new(success?: false, errors: e.message)
  end

  # Reserves the slot for the client
  # Returns an OpenStruct with :success? flag and the reservation
  def reserve_slot
    assert_slot_is_editable
    assert_slot_is_not_reserved
    assert_slot_can_be_booked

    @slot.update!(reserved: true, reserved_at: Time.current)

    @reservation = @client.reservations.build(slot: @slot)
    @reservation.save!

    @slot.reload
    OpenStruct.new(success?: true, reservation: @reservation)
  end

  # Confirms the reservation for the slot
  # Returns the reservation
  def confirm_slot
    assert_slot_is_editable
    raise StandardError, 'Reservation expired.' if @slot.reserved_at < 30.minutes.ago

    @slot.update!(editable: true, reserved: false, reserved_at: nil)
    @slot.reservation.update!(confirmed: true, confirmed_at: Time.current)
    @slot.reservation
  end

  private

  # Assertion methods
  def assert_slot_is_editable
    raise StandardError, 'Slot is not modifiable.' unless @slot.editable
  end

  def assert_slot_is_not_reserved
    raise StandardError, 'Slot is already reserved.' if @slot.reserved
  end

  def assert_slot_can_be_booked
    raise StandardError, 'Slot cannot be booked less than 24 hours in advance.' if @slot.start_at < 24.hours.from_now
  end
end
