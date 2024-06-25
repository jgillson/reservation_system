# Henry Meds Reservation System

# Getting Started

Follow these steps for setting up the application:

1. **Install Docker Desktop**  
   Download and install Docker Desktop from [here](https://www.docker.com/get-started/).

2. **Install ASDF**
   Download and install ASDF using the guide [here](https://asdf-vm.com/guide/getting-started.html).

3. **Install the Ruby plugin for ASDF**  
   Follow the instructions given [here](https://github.com/asdf-vm/asdf-ruby) to add the Ruby plugin to ASDF.

4. **Install Ruby**  
   Use the command `asdf install` to install Ruby.

5. **Set up the App**   
   Setup the app using `make build`.

6. **View API Routes**  
   Use command `make routes` to view all API routes

# Running the App

- Start the database: `make start`
    - To stop the database use: `make stop`
- Start the webserver with: `make start-server`

# Running Tests

1. Ensure the database is running: `make start`
2. To run the tests: `make rspec`

## API Documentation

The application provides several API endpoints under the base namespace /api/v1/. Below is the description and usage instructions for these APIs:

#### Get Provider Schedules (`GET /api/v1/providers/{id}/schedules`)
This endpoint returns the available time slots for a specific provider. Filters can be applied via query parameters.

- Parameters:
    - `id`: The id of the provider (required)
    - `date`: A date to filter time slots (optional, e.g., ?date=2023-08-01)

- Response: A JSON array of slots where `reserved == false` and `editable == true`.

#### Create Provider Schedules (`POST /api/v1/providers/{id}/schedules`)
This endpoint creates time slots for the specified provider.

- Parameters (required):
    - `id`: The id of the provider
    - `start_at`: The start time for the slots
    - `end_at`: The end time for the slots

- Response: A JSON array containing the created slots and a `200 OK` status.

#### Reserve a Slot (`POST /api/v1/providers/{id}/appointments/{id}/reserve`)
This endpoint allows a client to reserve a slot for a specific provider.

- Parameters (required):
    - `id`: The id of the provider
    - `appointment_id`: The id of the appointment
    - `client_id`: The id of the client

- Response: The id of the client booking object in a `200 OK` status response.

#### Confirm a Reserved Slot (`POST /api/v1/providers/{id}/appointments/{id}/confirm`)
This endpoint allows a client to confirm a previously reserved slot.

- Parameters (required):
    - `id`: The id of the provider
    - `appointment_id`: The id of the appointment
    - `client_booking_id`: The id of the client booking object

- Response: A `200 OK` status on success.

***Remember to replace `{id}` and other parameters in the endpoints with actual values.***

***Note: Error responses on all APIs should return a `400 BAD REQUEST` status alongside an error message within the JSON response.***

Below is a brief description of the application's database schema:

### Tables:

- `providers`: Holds information about the service providers.
    - `id`: Unique identifier
    - `name`: Provider's name
    - `created_at`: Record creation date
    - `updated_at`: Last update date

- `clients`: Stores the client's information.
    - `id`: Unique identifier
    - `name`: Client's name
    - `created_at`: Record creation date
    - `updated_at`: Last update date

- `schedules`: Contains the time slots for each provider.
    - `id`: Unique identifier
    - `provider_id`: Reference to the related provider
    - `start_at`: Slot start time
    - `end_at`: Slot end time
    - `created_at`: Record creation date
    - `updated_at`:  Last update date

- `reservations`: Represents the reservations made by clients.
    - `id`: Unique identifier
    - `client_id`: Reference to the related client
    - `schedule_id`: Reference to the related schedule
    - `confirmed`: Boolean indicating if the reservation is confirmed
    - `created_at`: Reservation creation date
    - `updated_at`: Last update date

### Relationships:

- A `Provider` has many `Schedules`
- A `Client` has many `Reservations`
- A `Schedule` belongs to a `Provider` and has many `Reservations`
- A `Reservation` belongs to a `Client` and a `Schedule`

# Limitations

## Reservation Rules
While certain reservation rules have been implemented, there are also some known limitations:

- Reservations will expire after 30 minutes if not confirmed. This functionality is implemented via the `expired_unconfirmed` scope method in the `Reservation` model.

- Reservations must be made at least 24 hours in advance. The enforcement of this rule is not currently implemented in the available code and remains a limitation of the system.

- **Important**: Be aware that the system does not currently re-make available slots from expired reservations for other clients. Also, it doesn't enforce the condition for making reservations at least 24 hours in advance. These limitations need to be handled in the future updates of the application.