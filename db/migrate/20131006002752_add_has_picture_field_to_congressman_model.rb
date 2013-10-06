class AddHasPictureFieldToCongressmanModel < ActiveRecord::Migration
  def up
    add_column :congressmen, :has_picture, :boolean

    Congressman.find_each do |c|
      c.update_attribute(:has_picture, c.has_picture?)
    end
  end

  def down
    remove_column :congressmen, :has_picture
  end
end
