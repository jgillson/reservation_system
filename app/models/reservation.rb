# The Reservation model belongs to both the Client and Slot models, representing a many-to-one relationship
# with each of these models. This means that each reservation belongs to a specific client and is for a specific slot.
# 
# The class also defines a scope `expired_unconfirmed` which fetches reservations that were created more 
# than 30 minutes ago and have not yet been confirmed.
class Reservation < ApplicationRecord
  # Defines a many-to-one association with the Client model.
  belongs_to :client

  # Defines a many-to-one association with the Slot model.
  belongs_to :slot

  # Defines a scope to fetch all reservations which are unconfirmed and were created more 
  # than 30 minutes ago.
  scope :expired_unconfirmed, -> { where("created_at < ? AND confirmed = false", 30.minutes.ago) }
end
