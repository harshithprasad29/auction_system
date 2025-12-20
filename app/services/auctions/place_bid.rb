# frozen_string_literal: true

module Auctions
  class PlaceBid
    BID_INCREMENT = 1

    def call(auction:, bidder_id:, amount:)
      raise ArgumentError, 'Auction has ended' if auction.ends_at < Time.current

      current_highest_amount = auction.bids.maximum(:amount) || 0
      minimum_allowed_amount = current_highest_amount + BID_INCREMENT

      raise ArgumentError, 'Bid amount too low' if amount < minimum_allowed_amount

      manual_bid = auction.bids.create!(
        bidder_id: bidder_id,
        amount: amount,
        bid_type: 'manual'
      )

      current_domain_bid = AuctionSystem::Bid.new(
        bidder_id: manual_bid.bidder_id,
        amount: manual_bid.amount,
        type: :manual
      )

      auto_bid = AuctionSystem::AutoBidResolver.resolve(
        current_highest_bid: current_domain_bid,
        auto_bids: auction.respond_to?(:auto_bids) ? auction.auto_bids : [],
        increment: BID_INCREMENT
      )

      if auto_bid
        auction.bids.create!(
          bidder_id: auto_bid.bidder_id,
          amount: auto_bid.amount,
          bid_type: 'auto'
        )

        return auto_bid
      end

      current_domain_bid
    end
  end
end
