class AddDatetoActivites < ActiveRecord::Migration[5.2]
  def change
    add_column :activites, :date, :datetime
  end
end
