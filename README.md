# Auction System

This project implements a backend auction system with support for manual bidding,
automatic bidding, and auction completion using a Minimum Selling Price (MSP).

The goal of this assignment was to focus on **correct business logic, clean design,
and testability**, rather than building a UI or deployment setup.

---

## How I Approached the Problem

I approached this problem by first identifying the **core business flows** of an
auction system:

1. Placing manual bids
2. Resolving automatic bids
3. Closing an auction and determining the outcome

Each of these flows is implemented as a **separate service**, keeping the logic
explicit and easy to reason about.

I intentionally avoided adding controllers or views, as the assignment focuses on
backend logic and correctness rather than presentation.

---

## High-Level Design

The application follows a simple and clear structure:

### Models
- `Auction`  
  Represents an auction listing and holds basic auction attributes.
- `Bid`  
  Represents individual bids placed on an auction.

The models are intentionally kept thin and focused on persistence only.

---

### Services
- `Auctions::PlaceBid`  
  Handles manual bid placement, including validation and persistence.

- `Auctions::CloseAuction`  
  Finalizes an auction, determines whether it is sold or unsold based on MSP,
  and identifies the winning bid if one exists.

---

### Domain Logic (lib)
- `AuctionSystem::AutoBidResolver`  
  Contains the logic to resolve automatic bids efficiently.
  It determines the winning auto-bid and the final bid amount using a single-pass
  algorithm (O(n)).

- `AuctionSystem::Notifier`  
  Acts as an abstraction for notifying an external system about the auction result.
  It is intentionally kept simple and treated as a boundary.

---

## Key Design Decisions & Assumptions

- **Bidding starts at 0**, as stated in the requirements.
- **Minimum Selling Price (MSP)** is enforced **only at auction close**, not during bidding.
- **Auto-bidding is reactive** and responds to existing bids.
- No system-generated bids are introduced.
- Time-based checks (`ends_at`) are assumed to be handled by the caller
  (for example, a scheduler or background job).
- Error handling uses **explicit guard clauses** instead of rescue-based control flow.
- No UI or API layer is included to keep the scope focused and intentional.

These decisions were made to avoid speculative features and keep the implementation
aligned with the stated requirements.

---

## Dependencies

- Ruby **3.4.7**
- Rails **8.x**
- SQLite (default database)
- Bundler for dependency management

All dependencies are declared in the `Gemfile`.

---

## Setup Instructions

From the project root, run:

```bash
bundle install
rails db:create db:migrate
bundle exec rspec
bundle exec rubocop