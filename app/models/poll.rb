class Poll < ::Renderable
  include E9Polls::Model

  has_many :poll_answers
  accepts_nested_attributes_for :poll_answers, :allow_destroy => true, :reject_if => :reject_answer?

  validates :template, :presence => true

  protected

  def reject_answer?(attributes)
    attributes.keys.member?(:value) && attributes[:value].blank?
  end
end
