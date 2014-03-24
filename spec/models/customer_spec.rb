require 'spec_helper'

describe Customer do

  context 'validations' do
    it { should validate_presence_of(:ref) }
    it { should validate_uniqueness_of(:ref) }
    it { should validate_presence_of(:total_shopping_credits) }
  end

  describe '#decrement_shopping_credits_by!' do
    context 'when amount to decrement is less than total shopping credits' do
      it 'decrements the shopping credits by the requested amount and returns true' do
        customer = FactoryGirl.create(:customer, total_shopping_credits: 100)
        amount = 55

        updated_customer = customer.decrement_shopping_credits_by!(amount)

        expect(updated_customer.total_shopping_credits).to be(45)
      end
    end

    context 'when amount to decrement is more than total shopping credits' do
      it 'does not decrement the shopping credits and returns false' do
        customer = FactoryGirl.create(:customer, total_shopping_credits: 100)
        amount = 105

        updated_customer = customer.decrement_shopping_credits_by!(amount)

        expect(updated_customer).to be(nil)
      end
    end
  end
end

