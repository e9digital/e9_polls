class PollAnswer < ActiveRecord::Base
  include E9Polls::Model
  belongs_to :poll
end
