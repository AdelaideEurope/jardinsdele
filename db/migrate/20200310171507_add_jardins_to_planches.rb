class AddJardinsToPlanches < ActiveRecord::Migration[5.2]
  def change
    add_column :planches, :jardin, :string
  end
end
