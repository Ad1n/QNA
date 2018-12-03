Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :vote
      post :unvote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, except: :index, concerns: [:votable] do
      member do
        post :choose_best_answer
      end
    end
  end

  resources :attachments, only: :destroy

end
