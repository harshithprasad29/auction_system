# frozen_string_literal: true

module AuctionSystem
  class AutoBidResolver
    def self.resolve(current_highest_bid:, auto_bids:, increment:)
      best = nil
      second_best = nil

      auto_bids.each do |auto_bid|
        next if auto_bid.max_amount < current_highest_bid.amount + increment

        if best.nil? || auto_bid.max_amount > best.max_amount
          second_best = best
          best = auto_bid
        elsif second_best.nil? || auto_bid.max_amount > second_best.max_amount
          second_best = auto_bid
        end
      end

      return nil unless best

      final_amount =
        if second_best
          [second_best.max_amount + increment, best.max_amount].min
        else
          current_highest_bid.amount + increment
        end

      Bid.new(
        bidder_id: best.bidder_id,
        amount: final_amount,
        type: :auto
      )
    end
  end
end
