module E9Polls
  #
  # Very simple module to alter the model_name.partial_path of E9Polls models
  #
  module Model
    extend ActiveSupport::Concern

    included do
      unless self.model_name.partial_path =~ /^e9_polls/
        self.model_name.instance_variable_set('@partial_path', File.join('e9_polls', self.model_name.partial_path).freeze)
      end
    end
  end
end
