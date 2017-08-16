class AddAuthorToArticles < ActiveRecord::Migration[5.1]
  def change
    add_reference :articles, :author, index: true
  end
end
