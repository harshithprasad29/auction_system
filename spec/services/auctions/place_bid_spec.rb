# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auctions::PlaceBid do
  let(:auction) do
    Auction.create!(
      title: 'Test Auction',
      minimum_selling_price: 0,
      ends_at: 1.hour.from_now
    )
  end

  subject(:service) { described_class.new }

  it 'allows first manual bid' do
    result = service.call(
      auction: auction,
      bidder_id: 'user_1',
      amount: 10
    )

    expect(result.amount).to eq(10)
    expect(auction.bids.count).to eq(1)
  end

  it 'rejects bid lower than current highest + increment' do
    auction.bids.create!(bidder_id: 'user_1', amount: 10, bid_type: 'manual')

    expect do
      service.call(
        auction: auction,
        bidder_id: 'user_2',
        amount: 10
      )
    end.to raise_error(ArgumentError)
  end

  it 'allows higher manual bid' do
    auction.bids.create!(bidder_id: 'user_1', amount: 10, bid_type: 'manual')

    result = service.call(
      auction: auction,
      bidder_id: 'user_2',
      amount: 15
    )

    expect(result.amount).to eq(15)
    expect(auction.bids.count).to eq(2)
  end
end
