#:nodoc:
class Admin::AppsController < ApplicationController
  def checkout
    @pagination = 5

    @pagination, @transactions = pagy(CheckoutTransaction.includes(:checkout_card)
      .order(created_at: :desc), items: params[:limit] ||= 20)

    @cards = CheckoutCard.joins(:member).select(:id, :uuid, :member_id).where(:active => false)

    @credit = CheckoutBalance.sum(:balance)
    @products = CheckoutProduct.where(:active => true).count
  end

  def payments
    @transactions = Payment.order(created_at: :desc)
    @transactions = @transactions.where(:transaction_type => params[:transaction]) unless params[:transaction].blank?
    @transactions = @transactions.where(:payment_type => params[:payment]) unless params[:payment].blank?
    @transactions = @transactions.search(params[:search]) unless params[:search].blank?
    @pagination, @transactions = pagy(@transactions, items: params[:limit] ||= 20)
  end
end
