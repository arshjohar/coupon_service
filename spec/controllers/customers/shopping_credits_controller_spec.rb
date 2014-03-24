require 'spec_helper'

module Customers
  describe ShoppingCreditsController do
    describe '#show' do
      context 'when customer is present in the database' do
        it 'gets the shopping credits for a customer' do
          customer = FactoryGirl.create(:customer, ref: 'customer1', total_shopping_credits: 100)

          get :show, {customer_id: 'customer1'}

          expect(assigns(:total_shopping_credits)).to be(customer.total_shopping_credits)
          expect(response).to render_template('show')
          expect(response.status).to be(200)
        end
      end

      context 'when customer is not present in the database' do
        it 'gives an error message indicating that the customer is not present' do
          get :show, {customer_id: 'invalid_customer_ref'}

          expect(assigns(:invalid_param)).to eq('customer_ref')
          expect(assigns(:description)).to eq('customer not present in database')
          expect(response).to render_template('shared/errors')
          expect(response.status).to be(404)
        end
      end
    end

    describe '#decrement' do
      context 'when customer is present in the database' do
        context 'shopping credits less than amount to decrement' do
          it 'gives an error message indicating the same' do
            FactoryGirl.create(:customer, ref: 'customer1', total_shopping_credits: 100)

            put :decrement, {customer_id: 'customer1', amount: 130}

            expect(assigns(:invalid_param)).to eq('amount')
            expect(assigns(:description)).to eq('amount to decrement more than total shopping credits')
          end
        end

        context 'shopping credits more than amount to decrement' do
          it 'decrements the shopping credits by the specified amount' do
            customer = FactoryGirl.create(:customer, ref: 'customer1')
            initial_shopping_credits = customer.total_shopping_credits
            amount_to_decrement = 70

            put :decrement, {customer_id: 'customer1', amount: amount_to_decrement}
            customer.reload

            expect(customer.total_shopping_credits).to be(initial_shopping_credits - amount_to_decrement)
          end
        end
      end

      context 'when customer is not present in the database' do
        it 'gives an error message indicating that the customer is not present' do
          get :show, {customer_id: 'invalid_customer_ref'}

          expect(assigns(:invalid_param)).to eq('customer_ref')
          expect(assigns(:description)).to eq('customer not present in database')
          expect(response).to render_template('shared/errors')
          expect(response.status).to be(404)
        end
      end
    end
  end
end
