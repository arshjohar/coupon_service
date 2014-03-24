class AddUniqueIndexToRefInCustomers < ActiveRecord::Migration
  def change
    add_index :customers, :ref, unique: true
  end
end
