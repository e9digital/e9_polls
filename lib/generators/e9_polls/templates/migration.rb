class CreateE9Polls < ActiveRecord::Migration
  def self.up
    create_table :poll_answers, :force => true do |t|
      t.references :poll
      t.integer :votes, :default => 0
      t.text :value
    end
  end

  def self.down
    drop_table :poll_answers
  end
end
