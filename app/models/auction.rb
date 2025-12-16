class Auction < ApplicationRecord
	has_many :bids, dependent: :destroy
	validates :minimum_selling_price, numericality: { greater_than_or_equal_to: 0 }
end
