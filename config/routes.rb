Rails.application.routes.draw do
  root 'raspberry_pis#edit'

  resource :raspberry_pis, only: [:edit, :update]
end
