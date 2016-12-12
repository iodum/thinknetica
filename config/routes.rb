Rails.application.routes.draw do
  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end
  concern :commentable do
    resources :comments, shallow: true, only: [:create]
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }

  as :user do
    get 'users/edit_email', to: 'registrations#edit_email', as: :edit_user_email
    post 'users/update_email', to: 'registrations#update_email', as: :update_user_email
  end

  root 'questions#index'

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, only: [:create, :edit, :update, :destroy], concerns: [:votable, :commentable], shallow: true do
      patch :accept, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
