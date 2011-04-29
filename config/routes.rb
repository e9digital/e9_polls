Rails.application.routes.draw do
  scope :module => :e9_polls do
    scope :path => :admin, :as => :admin do
      resources :polls, :except => :show, :controller => 'polls'
    end

    resources :polls, :only => :show, :controller => 'polls' do
      member do
        get :results
        put :answer
      end
    end

    # redirect admin show url to edit
    get "/admin/polls/:id", :to => redirect("/admin/polls/%{id}/edit"), :constraints => { :id => /\d+/ }
  end
end
