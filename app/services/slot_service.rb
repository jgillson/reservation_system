# The SlotService class is a service object that contains the business logic
# for creating slots based on a start time, an end time, and a provider.
#
# This service generates the slots in 15-minute increments, and these slots
# are created every 5 minutes from the start time until the end time, thus covering
# all possible time slots within the given time range.
#
# Finally, this class inserts all the new slots using the insert_all method,
# which is a bulk insert method provided by Active Record.
class SlotService
  # Generate and bulk inserts slots given a start time, end time and provider
  # The slots are created in 15 minutes increments while the time is increased by 5 minutes each time
  # Params: Start time, End time, Provider
  def make_slots(start_at, end_at, provider)
    slot_start = start_at.to_datetime
    slot_end = end_at.to_datetime
    new_slot_start = slot_start

    [].tap do |new_slots|
      while new_slot_start < slot_end
        if new_slot_start + 15.minutes <= slot_end
          new_slots << {
            start_at: new_slot_start,
            end_at: new_slot_start + 15.minutes,
            provider_id: provider.id,
            created_at: Time.now,
            updated_at: Time.now
          }
        end

        new_slot_start += 5.minutes
      end

      Slot.insert_all(new_slots)
    end
  end
end
