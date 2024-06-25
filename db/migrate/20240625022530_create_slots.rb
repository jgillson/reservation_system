class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :slots do |t|
      t.references :provider, null: false, foreign_key: true
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.boolean :editable, null: false, default: true
      t.boolean :reserved, null: false, default: false
      t.datetime :reserved_at

      t.timestamps
    end
  end
end
