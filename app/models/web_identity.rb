class WebIdentity < ActiveRecord::Base
  attr_accessible :website, :webform, :congress_office, :bioguide_id, :votesmart_id, :fec_id, :govtrack_id, :crp_id, :twitter_id, :congresspedia_url, :youtube_url, :facebook_id, :official_rss, :congressman_id

  belongs_to :congressman
end
