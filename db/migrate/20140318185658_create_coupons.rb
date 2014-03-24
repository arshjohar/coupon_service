class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons, id: false, primary_key: :code do |t|
      t.string :code, null: false
      t.string :referrer_customer_ref
      t.string :referred_customer_ref
      t.integer :shopping_credits_to_referrer_customer
      t.integer :shopping_credits_to_referred_customer
      t.timestamps
    end
  end
end
