Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, except: :index do
      member do
        post :choose_best_answer
      end
    end
  end
end
