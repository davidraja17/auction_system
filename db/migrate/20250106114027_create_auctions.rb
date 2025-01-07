class CreateAuctions < ActiveRecord::Migration[7.1]
  def change
    create_table :auctions do |t|
      t.string :title
      t.text :description
      t.decimal :starting_price, precision: 10, scale: 2
      t.decimal :msp, precision: 10, scale: 2
      t.integer :duration # in minutes
      t.datetime :ends_at
      t.references :seller, foreign_key: { to_table: :users }
      t.string :status, default: 'active'
      t.references :winner, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
