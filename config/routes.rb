Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, only: [:new, :create, :edit, :update, :destroy], shallow: true do
      patch :accept, on: :member
    end
  end

  resources :attachments, only: [:destroy]
end
