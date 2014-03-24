class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers, id: false, primary_key: :ref do |t|
      t.string :ref, null: false
      t.integer :total_shopping_credits, null: false, default: 0
    end
  end
end
