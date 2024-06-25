class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.references :client, null: false, foreign_key: true
      t.references :slot, null: false, foreign_key: true
      t.boolean :expired, null: false, default: false
      t.boolean :confirmed, null: false, default: false
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
