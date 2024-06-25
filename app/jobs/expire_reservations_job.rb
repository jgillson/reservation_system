# This ExpireReservationsJob class is a job schedule for expiring unconfirmed reservations.
# It inherits from ApplicationJob, which makes it a background job that can be queued for execution.
#
# The job goes through each unconfirmed reservation that has expired and
# updates the associated slot to no longer being reserved, and then destroys the reservation.
#
# This job is queued in the :default queue.
class ExpireReservationsJob < ApplicationJob
  queue_as :default

  # Goes through each expired, unconfirmed reservation.
  # For each reservation, it frees up the reserved slot and
  # destroys the reservation.
  def perform
    Reservation.expired_unconfirmed.find_each do |reservation|
      reservation.slot.update!(reserved: false)
      reservation.destroy
    end
  end
end
