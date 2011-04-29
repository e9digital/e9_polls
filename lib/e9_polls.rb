require 'rails'
require 'e9_base'

module E9Polls
  autoload :VERSION,    'e9_polls/version'
  autoload :Model,      'e9_polls/model' 

  mattr_accessor :fallback_html_layout
  @@fallback_html_layout = 'application'

  mattr_accessor :cookie_name
  @@cookie_name = 'e9_polls'

  mattr_accessor :bar_css_class_count
  @@bar_css_class_count = 5

  class Engine < ::Rails::Engine
    config.e9_crm = E9Polls

    initializer 'e9_polls.include_base_helper' do
      ActiveSupport.on_load(:action_view) do
        require 'e9_polls/global_helper'
        include E9Polls::GlobalHelper
      end
    end
  end
end
