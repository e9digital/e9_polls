require 'e9_base'

module E9Polls
  autoload :VERSION,  'e9_polls/version'
  autoload :Model,    'e9_polls/model' 

  mattr_accessor :fallback_html_layout
  @@fallback_html_layout = 'application'

  def E9Polls.init!
  end

  class Engine < ::Rails::Engine
    config.e9_crm = E9Polls
    config.to_prepare { E9Polls.init! }
  end
end
