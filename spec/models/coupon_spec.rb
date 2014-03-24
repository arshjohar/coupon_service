require 'spec_helper'

describe Coupon do
  context 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
  end

  context 'associations' do
    it { should belong_to(:referrer_customer).class_name('Customer').with_foreign_key(:referrer_customer_ref) }
    it { should belong_to(:referred_customer).class_name('Customer').with_foreign_key(:referred_customer_ref) }
  end

  describe 'custom validations' do
    describe 'referred_and_referrer_not_equal' do
      context 'referrer and referred customer are same' do
        it 'should be invalid' do
          coupon = FactoryGirl.create(:assigned_coupon)

          coupon.referred_customer_ref = coupon.referrer_customer_ref

          coupon.should_not be_valid
          coupon.errors.full_messages_for(:base).should == ["Referrer and referred customer can't be the same"]
        end
      end

      context 'referrer and referred customer are different' do
        it 'should be valid' do
          coupon = FactoryGirl.create(:assigned_coupon)

          coupon.referred_customer_ref = 'some_other_customer'

          coupon.should be_valid
        end
      end
    end
  end

  describe '#apply!' do
    context 'when coupon is successfully applied' do
      it 'updates the shopping credits of the related customers' do
        referrer_customer = FactoryGirl.create(:customer)
        initial_shopping_credits_of_referrer = referrer_customer.total_shopping_credits
        coupon = FactoryGirl.create(:assigned_coupon, referrer_customer: referrer_customer)
        referred_customer_ref = 'some_other_customer'
        shopping_credits_to_referrer_customer = 100
        shopping_credits_to_referred_customer = 10

        applied_coupon = coupon.apply!(referred_customer_ref, shopping_credits_to_referrer_customer, shopping_credits_to_referred_customer)
        referrer_customer.reload
        referred_customer = Customer.find_by(ref: referred_customer_ref)

        expect(applied_coupon.referred_customer_ref).to eq(referred_customer_ref)
        expect(applied_coupon.shopping_credits_to_referrer_customer).to be(shopping_credits_to_referrer_customer)
        expect(applied_coupon.shopping_credits_to_referred_customer).to be(shopping_credits_to_referred_customer)
        expect(referrer_customer.total_shopping_credits).to be(initial_shopping_credits_of_referrer + shopping_credits_to_referrer_customer)
        expect(referred_customer.total_shopping_credits).to be(shopping_credits_to_referred_customer)
      end
    end

    context 'when referred customer is the same as referrer' do
      it 'raises the appropriate error' do
        referrer_customer = FactoryGirl.create(:customer)
        coupon = FactoryGirl.create(:assigned_coupon, referrer_customer: referrer_customer)

        expect { coupon.apply!(referrer_customer.ref, 100, 100) }.to raise_error(CouponService::ReferredSameAsReferrerError)
      end
    end
    context 'when coupon is already applied' do
      it 'raises the appropriate error' do
        coupon = FactoryGirl.create(:applied_coupon)

        expect { coupon.apply!('some_referred_customer', 100, 100) }.to raise_error(CouponService::CouponAlreadyAppliedError)
      end
    end
  end
end
