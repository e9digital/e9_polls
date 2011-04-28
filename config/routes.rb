Rails.application.routes.draw do
  polls_admin_path = 'admin'

  scope :path => polls_admin_path, :module => :e9_polls do
    resources :polls, :except => :show, :controller => 'polls'
  end
end
