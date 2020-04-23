class CreateMemos < ActiveRecord::Migration[5.2]
  def change
    create_table :memos do |t|
      t.text :description
      t.datetime :date
      t.string :categorie

      t.timestamps
    end
  end
end
