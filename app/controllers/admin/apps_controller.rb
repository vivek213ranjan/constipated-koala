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
    if (params[:payment].blank? && params[:type].blank?)
      @pagination, @transactions = pagy(Payment.order(created_at: :desc), items: params[:limit] ||= 20)
    elsif params[:type].blank?
      @pagination, @transactions = pagy(Payment.where(:payment_type => params[:payment]).order(created_at: :desc), items: params[:limit] ||= 20)
    elsif params[:payment].blank?
      @pagination, @transactions = pagy(Payment.where(:transaction_type => params[:type]).order(created_at: :desc), items: params[:limit] ||= 20)
    else
      @pagination, @transactions = pagy(Payment.where(:transaction_type => params[:type], :payment_type => params[:payment]).order(created_at: :desc), items: params[:limit] ||= 20)
    end
  end

end
