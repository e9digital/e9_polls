class PollAnswer < ActiveRecord::Base
  include E9Polls::Model
  belongs_to :poll

  def as_json(options={})
    {}.tap do |hash|
      hash[:value]      = self.value
      hash[:votes]      = self.votes
      hash[:percentage] = self.percentage
    end
  end

  def vote!
    increment!(:votes)
  end

  def percentage
    poll.percentage_for(self)
  end
end
