class Customer < ActiveRecord::Base
  self.primary_key = :ref

  validates_presence_of :total_shopping_credits, :ref
  validates_uniqueness_of :ref

  def decrement_shopping_credits_by!(amount)
    updated_shopping_credits = self.total_shopping_credits - amount
    return nil if updated_shopping_credits < 0

    self.update_attributes(total_shopping_credits: updated_shopping_credits)
    self
  end
end
