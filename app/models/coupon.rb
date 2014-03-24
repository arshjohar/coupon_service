class Coupon < ActiveRecord::Base
  self.primary_key = :code

  validates_presence_of :code
  validates_uniqueness_of :code

  belongs_to :referrer_customer, class_name: 'Customer', foreign_key: :referrer_customer_ref
  belongs_to :referred_customer, class_name: 'Customer', foreign_key: :referred_customer_ref

  validate :referred_and_referrer_not_equal

  def apply!(referred_customer_ref, shopping_credits_to_referrer_customer, shopping_credits_to_referred_customer)
    raise CouponService::CouponAlreadyAppliedError if applied?

    applied = self.update_attributes(referred_customer_ref: referred_customer_ref,
                                     shopping_credits_to_referrer_customer: shopping_credits_to_referrer_customer,
                                     shopping_credits_to_referred_customer: shopping_credits_to_referred_customer)

    raise CouponService::ReferredSameAsReferrerError unless applied

    update_shopping_credits_of_related_customers
    self
  end


  private
  def applied?
    self.referred_customer_ref.present?
  end

  def referred_and_referrer_not_equal
    errors.add(:base, "Referrer and referred customer can't be the same") if referred_and_referrer_equal?
  end

  def referred_and_referrer_equal?
    self.referrer_customer_ref.present? && (self.referrer_customer_ref == self.referred_customer_ref)
  end

  def update_shopping_credits_of_related_customers
    referrer_customer = Customer.find_or_create_by(ref: self.referrer_customer_ref)
    referrer_customer.update_attributes(total_shopping_credits: referrer_customer.total_shopping_credits + self.shopping_credits_to_referrer_customer)

    referred_customer = Customer.find_or_create_by(ref: self.referred_customer_ref)
    referred_customer.update_attributes(total_shopping_credits: referred_customer.total_shopping_credits + self.shopping_credits_to_referred_customer)
  end
end
