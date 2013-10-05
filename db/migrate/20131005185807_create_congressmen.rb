class CreateCongressmen < ActiveRecord::Migration
  def change
    create_table :congressmen do |t|
      t.string :title
      t.string :firstname
      t.string :middlename
      t.string :lastname
      t.string :name_suffix
      t.string :party
      t.string :state
      t.string :district
      t.integer :in_office
      t.string :gender
      t.string :phone
      t.string :fax
      t.string :senate_class
      t.datetime :birthdate

      t.timestamps
    end
  end
end
