class CouponsController < ApplicationController
  include BlankParamsChecker

  def create
    @blank_params = get_blank_params(params, 'referrer_customer_ref')
    render_error and return if @blank_params.present?

    @coupon = Coupon.where(referrer_customer_ref: nil).first
    @coupon.update_attributes(referrer_customer_ref: params[:referrer_customer_ref])
    # Rendering a template called 'create', since post-redirects need to be implemented for browser refresh behaviour.
    # Such behaviour is not the case with APIs. So, there's no need to use post-redirects here.
    render 'create', formats: [:json]
  end

  def update
    @blank_params = get_blank_params(params, 'referred_customer_ref')
    render_error and return if @blank_params.present?

    coupon = Coupon.find_by(code: params[:id].downcase)
    if coupon.nil?
      @invalid_param = 'code'
      @description = 'coupon with specified code not present in database'
      render 'shared/errors', formats: [:json], status: :not_found and return
    end

    begin
      @applied_coupon = coupon.apply!(params[:referred_customer_ref], params[:shopping_credits_to_referrer_customer].to_i,
                                      params[:shopping_credits_to_referred_customer].to_i)
    rescue CouponService::CouponServiceError => e
      @invalid_param = e.invalid_param
      @description = e.description
      render 'shared/errors', formats: [:json], status: e.http_status_code and return
    end

    render 'update', formats: [:json]
  end

end
