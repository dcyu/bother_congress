class Authorization < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id, :user
  belongs_to :user
  validates :provider, :uid, :presence => true

  def self.find_or_create(auth_hash)
    puts auth_hash
    unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      name = auth_hash['info']['name']
      email = auth_hash['info']['email']
      user = User.create :name => name, :email => email
      auth = create :user_id => user.id, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end

    auth
  end
end
