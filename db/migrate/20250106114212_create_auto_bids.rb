class CreateAutoBids < ActiveRecord::Migration[7.1]
  def change
    create_table :auto_bids do |t|
      t.decimal :max_amount, precision: 10, scale: 2
      t.references :auction, foreign_key: true
      t.references :buyer, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
