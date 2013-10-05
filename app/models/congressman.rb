# == Schema Information
#
# Table name: congressmen
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  firstname    :string(255)
#  middlename   :string(255)
#  lastname     :string(255)
#  name_suffix  :string(255)
#  party        :string(255)
#  state        :string(255)
#  district     :string(255)
#  in_office    :integer
#  gender       :string(255)
#  phone        :string(255)
#  fax          :string(255)
#  senate_class :string(255)
#  birthdate    :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Congressman < ActiveRecord::Base
  attr_accessible :title, :firstname, :middlename, :lastname, :name_suffix, :party, :state, :district, :in_office, :gender, :phone, :fax, :senate_class, :birthdate

  has_one :web_identity
end
