Rails.application.routes.draw do
  mount ActionCable.server, at: '/cable'
  default_url_options :host => "103.166.185.90"
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get 'static_pages/home'
  get 'static_pages/about'
  get 'static_pages/login'
  get "/books", to: "books#index"
  get 'books/show'
  get 'books/create'
  get 'books/destroy'
  post 'books/read', to: "books#read"
  root "static_pages#home"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/register", to: "users#new"
  post "/register", to: "users#create"
  delete '/logout', to: 'sessions#destroy'
  get "/search", to: "books#search"
  get "/links", to: "links#index"
  get "/search_local_book", to: "local_books#search"
  post "search_local_book", to: "local_book#index"
  resources :users
  resources :books
  resources :local_books
  resources :password_resets, only: [:new, :create, :edit, :update]

  namespace :admin do
    root "statistics#index"
    get "/admin", to: "statistics#index"
    get "/books", to: "books#index"
    post "/books/:id", to: "books#update"
    get "/add_book", to: "books#new"
    post "/add_book", to: "books#create"
    get "/add_class", to: "class_users#new"
    post "/add_class", to: "class_users#create"
    get "/add_user", to: "users#new"
    post "/add_user", to: "users#create"
    get "/add_subject", to: "subjects#new"
    post "/add_subject", to: "subjects#create"
    get "/add_category", to: "categories#new"
    post "/add_category", to: "categories#create"
    get "/add_link", to: "links#new"
    post "/add_link", to: "links#create"
    get "/add_local_book", to: "local_books#new"
    post "/add_local_book", to: "local_books#create"
    resources :static_pages
    resources :books
    resources :local_books
    resources :users
    resources :class_users
    resources :subjects
    resources :categories
    resources :links
    resources :statistics
  end
end
