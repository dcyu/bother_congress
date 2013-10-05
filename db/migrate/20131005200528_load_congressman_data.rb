require 'csv'

class LoadCongressmanData < ActiveRecord::Migration
  def up
    congressmen = CSV.read("app/assets/congressmen.csv", :headers => true)

    # Could probably do this via introspection and responds_to?, but it's quicker to just type out the fields
    congressmen.each do |c|
      cur_congressman = Congressman.create(
        :title => c['title'],
        :firstname => c['firstname'],
        :middlename => c['middlename'],
        :lastname => c['lastname'],
        :name_suffix => c['name_suffix'],
        :party => c['party'],
        :state => c['state'],
        :district => c['district'],
        :in_office => c['in_office'],
        :gender => c['gender'],
        :phone => c['phone'],
        :fax => c['fax'],
        :senate_class => c['senate_class'],
        :birthdate => Date.parse(c['birthdate'])
      )

      WebIdentity.create(
        :website => c['website'],
        :webform => c['webform'],
        :congress_office => c['congress_office'],
        :bioguide_id => c['bioguide_id'],
        :votesmart_id => c['votesmart_id'],
        :fec_id => c['fec_id'],
        :govtrack_id => c['govtrack_id'],
        :crp_id => c['crp_id'],
        :twitter_id => c['twitter_id'],
        :congresspedia_url => c['congresspedia_url'],
        :youtube_url => c['youtube_url'],
        :facebook_id => c['facebook_id'],
        :official_rss => c['official_rss'],
        :congressman_id => cur_congressman.id
      )
    end
  end

  def down
    Congressman.destroy_all
    WebIdentity.destroy_all
  end
end
