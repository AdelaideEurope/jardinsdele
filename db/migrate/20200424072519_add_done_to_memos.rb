class AddDoneToMemos < ActiveRecord::Migration[5.2]
  def change
    add_column :memos, :done, :boolean, default: false
  end
end
