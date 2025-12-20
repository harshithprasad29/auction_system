# frozen_string_literal: true

class CreateBids < ActiveRecord::Migration[8.1]
  def change
    create_table :bids do |t|
      t.references :auction, null: false, foreign_key: true
      t.string :bidder_id
      t.integer :amount
      t.string :bid_type

      t.timestamps
    end
  end
end
