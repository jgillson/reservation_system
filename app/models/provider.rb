# The Provider model has a one-to-many relationship with the Slot model,
# meaning that a provider can potentially have multiple slots associated with it.
class Provider < ApplicationRecord
  # Defines a one-to-many association with the Slot model.
  # If a Provider object is destroyed, the associated Slot objects will also 
  # be destroyed.
  has_many :slots
end
