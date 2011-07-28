class Poll < ::Renderable
  include E9Polls::Model
  include E9Rails::ActiveRecord::InheritableOptions

  self.options_parameters = [
    :header_text
  ]

  has_many :poll_answers

  accepts_nested_attributes_for :poll_answers, :allow_destroy => true, :reject_if => :reject_answer?

  validates :template, :presence => true

  def vote
    nil
  end

  def as_json(options={})
    {}.tap do |hash|
      hash[:id]       = self.id,
      hash[:name]     = self.name,
      hash[:question] = self.question,
      hash[:answers]  = self.answers,
      hash[:errors]   = self.errors
    end
  end

  def question
    template
  end

  def answers
    poll_answers
  end

  def vote=(id)
    poll_answers.find_by_id(id).try(:vote!)
  end

  def votes
    poll_answers.sum(:votes).to_i
  end

  def percentage_for(poll_answer)
    votes.zero? ? 0 : (poll_answer.votes.to_f / votes * 100).round(2)
  end

  protected

  def reject_answer?(attributes)
    !attributes.keys.member?('value') || attributes['value'].blank?
  end
end
