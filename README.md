# Rails Engine

API for fetching information about Merchants, Items, and Invoices
modeled off of the back-end functionality for a large product
distribution center.

## Versions

- Ruby 2.7.2
- Rails 5.2.6
- PostgreSQL 0.18 < 2.0

## Local Setup

1. Fork and clone repo
2. `bundle install`
3. `rails db:{create,seed}`
  - do NOT run a migration, pgdump in seeding will create the required tables
4. `rails db:schema:dump`

## Endpoints

### V1

- Merchants
  - `/merchants`
  - `/merchants/:id`
  - `/merchants/:id/items`

- Items
  - `/items`
  - `/items/:id` get, post, patch, delete
  - `/items/:id/merchant`

- Item, Merchant Searching
  - `/merchants/find`
  - `/merchants/find_all`
  - `/merchants/most_items`
  - `/items/find`
  - `/items/find_all`

- Revenue Details
  - `/revenue`
  - `/revenue/unshipped`
  - `/revenu/merchants`
  - `/revenue/merchants/:merchant_id`
  - `/revenue/items`
  - `/revenue/weekly`

## Testing

- Testing done with RSpec and monitored with SimpleCov
  - suite covers 100% of models, requests
- `bundle exec rspec`

## Authors
- [Tanner Dale](https://github.com/TannerDale)
