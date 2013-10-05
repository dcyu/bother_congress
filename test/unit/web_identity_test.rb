# == Schema Information
#
# Table name: web_identities
#
#  id                :integer          not null, primary key
#  website           :string(255)
#  webform           :string(255)
#  congress_office   :string(255)
#  bioguide_id       :string(255)
#  votesmart_id      :string(255)
#  fec_id            :string(255)
#  govtrack_id       :string(255)
#  crp_id            :string(255)
#  twitter_id        :string(255)
#  congresspedia_url :string(255)
#  youtube_url       :string(255)
#  facebook_id       :string(255)
#  official_rss      :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  congressman_id    :integer
#

require 'test_helper'

class WebIdentityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
