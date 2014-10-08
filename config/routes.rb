Rails.application.routes.draw do

  resources :categories
  mount Ckeditor::Engine => '/ckeditor'
  resources :sites


  namespace :'api', defaults: {format: :json} do
    devise_scope :user do
      resource :session, only: [:create, :destroy]
    end

    resources :categories
    resources :portfolios
    resources :themes

    resources :jobs do
      resources :applicants
    end

    # match 'blog' => "posts#index",      :as => :blog  , via: [:get, :post]

    resources :posts do
      member do
        get :published
        get :unpublished
        get :user_profile
        put :like
        put :dislike
      end

      collection do
        get :blog_posts
      end

      resources :contacts
      resources :comments

    end
  end
  # match 'blog' => "posts#index",      :as => :blog  , via: [:get, :post]
# scope :api-old , defaults: { format: 'json' } do
  resources :themes
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks", registrations: "registrations"}


  resources :jobs do
    resources :applicants
  end

  resources :posts do
    member do
      get :published
      get :unpublished
      get :user_profile
      put :like
      put :dislike
    end
    collection do
      get :blog_posts
    end
    resources :contacts
    resources :comments
  end
  resources :portfolios

  root to: "home#index"

end
