module Customers
  class ShoppingCreditsController < ApplicationController
    before_filter :check_customer_presence

    def show
      @total_shopping_credits = @customer.total_shopping_credits

      render 'show', formats: [:json]
    end

    def decrement
      unless @customer.decrement_shopping_credits_by!(params[:amount].to_i)
        @invalid_param = 'amount'
        @description = 'amount to decrement more than total shopping credits'
        render 'shared/errors', formats: [:json], status: 400 and return
      end

      render 'decrement', formats: [:json]
    end

    private
    def check_customer_presence
      customer_ref = params[:customer_id]
      @customer = Customer.where(ref: customer_ref).first
      if @customer.nil?
        @invalid_param = 'customer_ref'
        @description = 'customer not present in database'
        render 'shared/errors', formats: [:json], status: 404
      end
    end
  end
end
