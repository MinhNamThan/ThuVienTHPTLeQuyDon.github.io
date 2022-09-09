class ChangeDataTypeForDescribe < ActiveRecord::Migration[6.1]
  def change
    change_column(:books, :describe, :text)
  end
end
