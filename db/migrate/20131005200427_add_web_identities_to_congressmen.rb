class AddWebIdentitiesToCongressmen < ActiveRecord::Migration
  def change
    add_column :web_identities, :congressman_id, :integer
  end
end
