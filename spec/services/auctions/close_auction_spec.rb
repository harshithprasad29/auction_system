# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auctions::CloseAuction do
  subject(:service) { described_class.new }

  let(:auction) do
    Auction.create!(
      title: 'Test Auction',
      minimum_selling_price: minimum_selling_price,
      ends_at: 1.day.from_now,
      status: 'open'
    )
  end

  let(:minimum_selling_price) { 0 }

  describe '#call' do
    context 'when auction is already closed' do
      it 'raises an error' do
        auction.update!(status: 'closed')

        expect do
          service.call(auction: auction)
        end.to raise_error(ArgumentError, 'Auction already closed')
      end
    end

    context 'when auction has no bids' do
      it 'marks the auction as unsold and returns nil' do
        result = service.call(auction: auction)

        expect(result).to be_nil
        expect(auction.reload.status).to eq('unsold')
      end
    end

    context 'when auction has bids but does not meet MSP' do
      let(:minimum_selling_price) { 100 }

      before do
        auction.bids.create!(
          bidder_id: 'user_1',
          amount: 80,
          bid_type: 'manual'
        )
      end

      it 'marks the auction as unsold' do
        result = service.call(auction: auction)

        expect(result).to be_nil
        expect(auction.reload.status).to eq('unsold')
      end
    end

    context 'when auction has bids and meets MSP' do
      let(:minimum_selling_price) { 50 }

      before do
        auction.bids.create!(
          bidder_id: 'user_1',
          amount: 50,
          bid_type: 'manual'
        )

        auction.bids.create!(
          bidder_id: 'user_2',
          amount: 80,
          bid_type: 'auto'
        )
      end

      it 'marks the auction as sold and returns the highest bid' do
        result = service.call(auction: auction)

        expect(auction.reload.status).to eq('sold')
        expect(result.bidder_id).to eq('user_2')
        expect(result.amount).to eq(80)
        expect(result.type).to eq(:auto)
      end
    end
  end
end
