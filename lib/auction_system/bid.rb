module AuctionSystem
	class Bid
		attr_reader :bidder_id, :amount, :type

		def initialize(bidder_id:, amount:, type:)
			@bidder_id = bidder_id
			@amount = amount
			@type = type
		end
	end
end