class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|

      t.timestamps
    end
  end
end
