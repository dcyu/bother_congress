class Congressman < ActiveRecord::Base
  attr_accessible :title, :firstname, :middlename, :lastname, :name_suffix, :party, :state, :district, :in_office, :gender, :phone, :fax, :senate_class, :birthdate

  has_one :web_identity
end
