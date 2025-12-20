# frozen_string_literal: true

class Auction < ApplicationRecord
  has_many :bids, dependent: :destroy
  validates :minimum_selling_price, numericality: { greater_than_or_equal_to: 0 }

  enum :status, {
    open: 'open',
    sold: 'sold',
    unsold: 'unsold',
    closed: 'closed'
  }
end
