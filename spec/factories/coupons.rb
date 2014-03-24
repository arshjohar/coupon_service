FactoryGirl.define do
  sequence :coupon_code do |n|
    "code#{n}"
  end

  factory :coupon do
    code FactoryGirl.generate(:coupon_code)
  end

  factory :assigned_coupon, parent: :coupon do
    referrer_customer_ref 'customer1'
  end

  factory :applied_coupon, parent: :assigned_coupon do
    referred_customer_ref 'customer2'
  end
end
