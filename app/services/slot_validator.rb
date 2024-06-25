# The SlotValidator class is a service object responsible for validating the
# conditions of a slot.  It checks whether the start and end times of a slot are in
# 5 minute increments, if the duration is at least 15 minutes, and if there are any overlaps
# with existing slots for the same provider.
#
# Upon validating a slot, it sets an error message if the slot fails any of the above conditions.
# The error can be accessed via the :error attribute reader.
#
# The class also provides methods to retrieve overlapping slots for a given time range or a slot.
class SlotValidator
  # Minimum number of minutes for a slot duration
  MIN_SLOT_DURATION = 15

  ERROR_INVALID_INCREMENT = "Both the start and end time must be in 5 minute increments"
  ERROR_DURATION_TOO_SHORT = "The start and end times must be at least 15 minutes apart"
  ERROR_OVERLAPS_EXISTING = "Overlaps with existing slot"

  attr_reader :error

  # Checks if a given time range is a valid slot for a provider.
  # Params: Start time, End time, Provider
  def is_valid?(start_at, end_at, provider)
    slot_start = start_at.to_datetime
    slot_end = end_at.to_datetime

    valid_increment = valid_increment?(slot_start) && valid_increment?(slot_end)
    sufficient_duration = minutes_difference(slot_start, slot_end) >= MIN_SLOT_DURATION
    no_overlap = overlapping_for_range(start_at, end_at, provider).count.zero?

    if !valid_increment
      @error = ERROR_INVALID_INCREMENT
    elsif !sufficient_duration
      @error = ERROR_DURATION_TOO_SHORT
    elsif !no_overlap
      @error = ERROR_OVERLAPS_EXISTING
    end

    valid_increment && sufficient_duration && no_overlap
  end

  # Finds slots that overlap with a given time range for a provider.
  # Params: Start time, End time, Provider
  def overlapping_for_range(start_at, end_at, provider)
    slot_start = start_at.to_datetime
    slot_end = end_at.to_datetime

    Slot.where(provider: provider).where("start_at < ? AND ? < end_at", slot_end, slot_start)
  end

  # Finds slots that overlap with a given slot, excluding the slot itself.
  # Params: Slot
  def overlapping_for_slot(slot)
    overlapping_for_range(slot.start_at, slot.end_at, slot.provider).where.not(id: slot.id)
  end

  private

  # A private method that checks if a given time is in 5 minute increments.
  # This is done by checking if the minute part of the time object can be divided evenly by 5.
  # If any error occurs during the calculation (for instance if the input is not a time object),
  # it will rescue the error and return false.
  def valid_increment?(time)
    begin
      # 5 min increments, i.e., start_time and end_time both end in 0 or 5
      time.min % 5 == 0
    rescue StandardError
      false
    end
  end

  # A private method that calculates the difference in minutes between two time objects.
  # The subtraction of slot_start from slot_end gives a difference in days. To convert this to
  # minutes, it's multiplied by the number of hours in a day (24) and minutes in an hour (60).
  # This method will return 0 if any error occurs during the calculation.
  def minutes_difference(slot_start, slot_end)
    begin
      # Difference in days so need to multiply by num hours in day and num minutes per hour
      ((slot_end - slot_start) * 24 * 60).to_i
    rescue StandardError
      0
    end
  end
end
