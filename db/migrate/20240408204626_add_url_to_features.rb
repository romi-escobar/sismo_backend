class AddUrlToFeatures < ActiveRecord::Migration[7.1]
  def change
    add_column :features, :url, :string
  end
end
