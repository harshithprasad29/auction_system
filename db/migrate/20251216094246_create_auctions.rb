# frozen_string_literal: true

class CreateAuctions < ActiveRecord::Migration[8.1]
  def change
    create_table :auctions do |t|
      t.string :title
      t.text :description
      t.integer :minimum_selling_price
      t.datetime :ends_at

      t.timestamps
    end
  end
end
