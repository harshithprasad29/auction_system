# frozen_string_literal: true

require 'rails_helper'
require 'ostruct'

RSpec.describe AuctionSystem::AutoBidResolver do
  let(:increment) { 1 }

  let(:current_bid) do
    AuctionSystem::Bid.new(
      bidder_id: 'manual_user',
      amount: 50,
      type: :manual
    )
  end

  describe '.resolve' do
    it 'returns nil when there are no auto bids' do
      result = described_class.resolve(
        current_highest_bid: current_bid,
        auto_bids: [],
        increment: increment
      )

      expect(result).to be_nil
    end

    it 'returns nil when no auto bidder can beat the current bid' do
      auto_bids = [
        OpenStruct.new(bidder_id: 'A', max_amount: 50),
        OpenStruct.new(bidder_id: 'B', max_amount: 49)
      ]

      result = described_class.resolve(
        current_highest_bid: current_bid,
        auto_bids: auto_bids,
        increment: increment
      )

      expect(result).to be_nil
    end

    it 'resolves auto bid when a single auto bidder can beat the current bid' do
      auto_bids = [
        OpenStruct.new(bidder_id: 'A', max_amount: 60)
      ]

      result = described_class.resolve(
        current_highest_bid: current_bid,
        auto_bids: auto_bids,
        increment: increment
      )

      expect(result.bidder_id).to eq('A')
      expect(result.amount).to eq(51)
      expect(result.type).to eq(:auto)
    end

    it 'resolves auto bid between multiple auto bidders correctly' do
      auto_bids = [
        OpenStruct.new(bidder_id: 'A', max_amount: 100),
        OpenStruct.new(bidder_id: 'B', max_amount: 80)
      ]

      result = described_class.resolve(
        current_highest_bid: current_bid,
        auto_bids: auto_bids,
        increment: increment
      )

      expect(result.bidder_id).to eq('A')
      expect(result.amount).to eq(81)
      expect(result.type).to eq(:auto)
    end
  end
end
