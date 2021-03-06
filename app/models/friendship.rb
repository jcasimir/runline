class Friendship < ActiveRecord::Base
  attr_accessor :friend_name
  belongs_to :user 
  belongs_to :friend, :class_name => "User"

  validates :user_id, presence: true
  validates :friend_id, presence: true
  validates :status, presence: true

  def approve
    self.update_attributes(:status => "approved")
  end

  def remove
    self.destroy
  end

  def reject
    self.destroy
  end

end
