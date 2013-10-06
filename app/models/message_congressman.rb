class MessageCongressman < ActiveRecord::Base
  attr_accessible :congressman_id, :message_id
  validates :congressman_id, :message_id, :presence => true
  belongs_to :message
  belongs_to :congressman
end
