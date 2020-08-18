class CreateEncouragements < ActiveRecord::Migration[5.2]
  def change
    create_table :encouragements do |t|

      t.timestamps
    end
  end
end
