class CreatePlanches < ActiveRecord::Migration[5.2]
  def change
    create_table :planches do |t|
      t.string :nom

      t.timestamps
    end
  end
end
