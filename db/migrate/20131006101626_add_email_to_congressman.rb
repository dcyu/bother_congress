class AddEmailToCongressman < ActiveRecord::Migration
  def change
      add_column :congressmen, :email, :string
  end
end
