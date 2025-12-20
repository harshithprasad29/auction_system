# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuctionSystem::Notifier do
  describe '.notify_auction_result' do
    let(:auction) do
      Auction.create!(
        title: 'Test Auction',
        minimum_selling_price: 100,
        ends_at: 1.day.from_now,
        status: 'open'
      )
    end

    context 'when there is a winner' do
      let(:winner_bid) do
        AuctionSystem::Bid.new(
          bidder_id: 'user_1',
          amount: 150,
          type: :manual
        )
      end

      it 'notifies successfully without error' do
        expect do
          described_class.notify_auction_result(
            auction: auction,
            winner_bid: winner_bid
          )
        end.not_to raise_error
      end
    end

    context 'when there is no winner' do
      it 'notifies successfully without error' do
        expect do
          described_class.notify_auction_result(
            auction: auction,
            winner_bid: nil
          )
        end.not_to raise_error
      end
    end
  end
end
