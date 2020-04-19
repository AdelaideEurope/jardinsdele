class CreatePrevisionnelPlanches < ActiveRecord::Migration[5.2]
  def change
    create_table :previsionnel_planches do |t|
      t.references :legume, foreign_key: true
      t.references :planche, foreign_key: true
      t.decimal :total_previ

      t.timestamps
    end
  end
end
