class CreateMessageCongressmen < ActiveRecord::Migration
  def change
    create_table :message_congressmen do |t|
      t.integer :message_id
      t.integer :congressman_id

      t.timestamps
    end
  end
end
