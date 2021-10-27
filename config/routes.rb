Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope :merchants do
        get '/find', controller: :merchant_search, action: :find, as: :merchant_find
        get '/find_all', controller: :merchant_search, action: :find_all, as: :merchant_find_all
        get '/most_items', controller: :merchant_search, action: :items_sold, as: :merchants_by_items_sold
      end

      resources :merchants, only: %i[index show] do
        resources :items, only: :index
      end

      scope :items do
        get '/find', controller: :item_search, action: :find, as: :item_find
        get '/find_all', controller: :item_search, action: :find_all, as: :item_find_all
      end

      resources :items do
        get '/merchant', controller: :merchants, action: :show
      end

      namespace :revenue do
        get '/unshipped', to: 'revenue#unshipped'
        resources :merchants, only: %i[index show]
        get '/items', to: 'items#revenue'
        get '/weekly', to: 'revenue#weekly'
      end
    end
  end
end
