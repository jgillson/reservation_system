require "rails_helper"

RSpec.describe ExpireReservationsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:confirmed_reservation) { create(:reservation, confirmed: true) }
  let!(:expired_unconfirmed_reservation) { create(:reservation, confirmed: false, created_at: 31.minutes.ago) }
  let!(:recent_unconfirmed_reservation) { create(:reservation, confirmed: false, created_at: 10.minutes.ago) }

  describe "#perform_later" do
    it "enqueues the job" do
      expect { ExpireReservationsJob.perform_later }
        .to enqueue_job(ExpireReservationsJob)
    end
  end

  describe "#perform_now" do
    before do
      ExpireReservationsJob.perform_now
    end

    it "does not delete the confirmed reservation" do
      expect(Reservation.find_by(id: confirmed_reservation.id)).to eq(confirmed_reservation)
    end

    it "deletes the expired unconfirmed reservation" do
      expect(Reservation.find_by(id: expired_unconfirmed_reservation.id)).to be_nil
    end

    it "does not delete the recent unconfirmed reservation" do
      expect(Reservation.find_by(id: recent_unconfirmed_reservation.id)).to eq(recent_unconfirmed_reservation)
    end

    it "frees up the slot of expired unconfirmed reservation" do
      expect(Slot.find(expired_unconfirmed_reservation.slot_id).reserved).to equal(false)
    end
  end
end
