Rails.application.routes.draw do
  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  devise_for :users
  root 'questions#index'

  resources :questions, concerns: [:votable] do
    resources :answers, only: [:new, :create, :edit, :update, :destroy], concerns: [:votable], shallow: true do
      patch :accept, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
