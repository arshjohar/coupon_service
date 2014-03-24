FactoryGirl.define do
  sequence :customer_ref do |n|
    "customer#{n}"
  end


  factory :customer do
    ref FactoryGirl.generate(:customer_ref)
    total_shopping_credits 100
  end
end
