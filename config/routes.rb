Crypto::Application.routes.draw do
  devise_for :admins
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  #
  resource :account do
    resource :desired_portfolio do
      resources :desired_portfolio_items, :as => :items do
      end
    end
  end
  get 'accounts' => 'accounts#index', :as => :accounts_index
  get 'account/become/:id' => 'accounts#become', :as => :become_account

  resources :markets do
    member do
      get :data
    end
    resources :market_states do
    end
    resources :market_trades do
    end
  end

  resource :backtracker do
    resources :backtrack_runs do
      collection do
        get :export
      end
      resources :backtrack_results
    end
  end

  get 'partials/navbar_stats' => 'partials#navbar_stats'
  get 'partials/bot_run_actions' => 'partials#bot_run_actions'
  get 'partials/account_trades' => 'partials#account_trades'
  get 'partials/accounts_positions' => 'partials#accounts_positions'
  get 'partials/order_books' => 'partials#order_books'

  # You can have the root of your site routed with "root"
  authenticated :user do
    root 'accounts#show', :as => 'authenticated_user'
  end
  authenticated :admin do
    root 'accounts#index', :as => 'authenticated_admin'
  end
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
