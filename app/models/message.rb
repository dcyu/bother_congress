class Message < ActiveRecord::Base
  attr_accessible :message, :user_id
  has_many :congressmen, through: :message_congressmen
  belongs_to :user
  validates :message, :user_id, :presence => true


  class << self
    def create_from_message_user_congressman(message, user, congressman)
      m = Message.create(:message => message, :user_id => user.id)
      MessageCongressman.create(:message_id => m.id, :congressman_id => congressman.id)
      return m
    end
  end
end
