class CreateAssistants < ActiveRecord::Migration[5.2]
  def change
    create_table :assistants do |t|
      t.string :nom

      t.timestamps
    end
  end
end
