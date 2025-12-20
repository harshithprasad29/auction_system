# frozen_string_literal: true

class AddStatusToAuctions < ActiveRecord::Migration[8.1]
  def change
    add_column :auctions, :status, :string, default: 'open', null: false
    add_index :auctions, :status
  end
end
