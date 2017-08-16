class AddNameToAuthors < ActiveRecord::Migration[5.1]
  def change
    add_column :authors, :first_name, :string
    add_column :authors, :last_name, :string
  end
end
