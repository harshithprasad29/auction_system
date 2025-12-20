# frozen_string_literal: true

module Auctions
  class CloseAuction
    def call(auction:)
      raise ArgumentError, 'Auction already closed' if auction.status == 'closed'

      highest_bid = auction.bids.order(amount: :desc).first

      if highest_bid.nil?
        auction.update!(status: 'unsold')

        AuctionSystem::Notifier.notify_auction_result(
          auction: auction,
          winner_bid: nil
        )

        return nil
      end

      if auction.minimum_selling_price &&
         highest_bid.amount < auction.minimum_selling_price
        auction.update!(status: 'unsold')

        AuctionSystem::Notifier.notify_auction_result(
          auction: auction,
          winner_bid: nil
        )

        return nil
      end

      auction.update!(status: 'sold')

      winner = AuctionSystem::Bid.new(
        bidder_id: highest_bid.bidder_id,
        amount: highest_bid.amount,
        type: highest_bid.bid_type.to_sym
      )

      AuctionSystem::Notifier.notify_auction_result(
        auction: auction,
        winner_bid: winner
      )

      winner
    end
  end
end
