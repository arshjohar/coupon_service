require 'spec_helper'

describe CouponsController do

  describe '#create' do

    context 'when required params are absent' do
      it 'renders errors template and instantiates the required params into blank_params' do
        post :create, {referrer_customer_ref: nil}

        expect(assigns(:blank_params)).to eq(%w(referrer_customer_ref))
        expect(response).to render_template('shared/errors')
        expect(response.status).to be(400)
      end
    end

    context 'when required params are present' do
      it 'assigns a new coupon to the referrer customer' do
        unassigned_coupon = FactoryGirl.create(:coupon)
        referrer_customer_ref = 'abcd'

        post :create, {referrer_customer_ref: referrer_customer_ref}

        expect(controller.instance_variable_get(:@coupon).code).to eq(unassigned_coupon.code)
        expect(controller.instance_variable_get(:@coupon).referrer_customer_ref).to eq(referrer_customer_ref)
        expect(response).to render_template('create')
        expect(response.status).to be(200)
      end
    end
  end

  describe '#update' do
    context 'when required params are absent' do
      it 'renders errors template and instantiates the required params into blank_params' do
        put :update, {id: 'xyz', referred_customer_ref: nil}

        expect(assigns(:blank_params)).to eq(%w(referred_customer_ref))
        expect(response).to render_template('shared/errors')
        expect(response.status).to be(400)
      end
    end

    context 'when required params are present' do
      context 'coupon with the requested code is not present' do
        it 'gives an error indicating invalid coupon code' do
          put :update, {id: 'xyz', referred_customer_ref: 'pax'}

          expect(assigns(:invalid_param)).to eq('code')
          expect(assigns(:description)).to eq('coupon with specified code not present in database')
          expect(response).to render_template('shared/errors')
          expect(response.status).to be(404)
        end
      end

      context 'coupon with the requested code is present' do
        it 'sets the applied coupon' do
          assigned_coupon = FactoryGirl.create(:assigned_coupon)

          put :update, {id: assigned_coupon.code, referred_customer_ref: 'some_customer',
                        shopping_credits_to_referrer_customer: 10, shopping_credits_to_referred_customer: 20}
          assigned_coupon.reload

          expect(assigns(:applied_coupon)).to eq(assigned_coupon)
          expect(response).to render_template('update')
          expect(response.status).to be(200)
        end
      end

      context 'apply fails for the coupon' do
        it 'sets the invalid_param and description for the same' do
          assigned_coupon = FactoryGirl.create(:assigned_coupon)
          expected_invalid_param = 'some_invalid_param'
          expected_description = 'some_description'
          expected_http_status_code = 400
          allow_any_instance_of(Coupon).to receive(:apply!).and_raise(CouponService::CouponServiceError.
                                                                          new(expected_invalid_param,
                                                                              expected_description,
                                                                              expected_http_status_code))

          put :update, {id: assigned_coupon.code, referred_customer_ref: assigned_coupon.referrer_customer_ref,
                        shopping_credits_to_referrer_customer: 10, shopping_credits_to_referred_customer: 20}

          expect(assigns(:invalid_param)).to eq(expected_invalid_param)
          expect(assigns(:description)).to eq(expected_description)
          expect(response).to render_template('shared/errors')
          expect(response.status).to be(expected_http_status_code)
        end
      end
    end
  end
end
