# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email
  has_many :authorizations
  validates :name, :presence => true


  def add_provider(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    end
  end

  def has_facebook
    return !Authorization.find_by_provider_and_user_id('facebook', id).nil?
  end

  def has_twitter
    return !Authorization.find_by_provider_and_user_id('twitter', id).nil?
  end

  def has_email
    return (!email.nil?) && (!email.empty?)
  end


end
