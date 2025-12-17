module Auctions
  class PlaceBid
    BID_INCREMENT = 1

    def call(auction:, bidder_id:, amount:)
      raise 'Auction has ended' if auction.ends_at < Time.current

      current_highest = auction.bids.maximum(:amount) || 0

      if amount < current_highest + BID_INCREMENT
        raise ArgumentError, 'Bid amount too low'
      end

      bid = auction.bids.create!(
        bidder_id: bidder_id,
        amount: amount,
        bid_type: 'manual'
      )

      AuctionSystem::Bid.new(
        bidder_id: bid.bidder_id,
        amount: bid.amount,
        type: bid.bid_type
      )
    end
  end
end
