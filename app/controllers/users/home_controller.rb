class Users::HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :confirm_add_funds ]
  skip_before_action :authenticate_admin!, only: [ :index, :edit, :update, :add_funds, :confirm_add_funds ]
  before_action :set_locale
  

  def index
    @member = Member.find(current_user.credentials_id)
    @activities = (@member.activities.joins(:participants).where(:participants => { :paid => false, :member => @member } ).distinct + @member.activities.order(start_date: :desc).limit(10)).uniq.sort_by(&:start_date).reverse
    @transactions = CheckoutTransaction.where( :checkout_balance => CheckoutBalance.find_by_member_id(current_user.credentials_id)).order(created_at: :desc).limit(10)
  end

  def edit
    @member = Member.includes(:educations).includes(:tags).find(current_user.credentials_id)
    
     if @member.educations.length < 1
       @member.educations.build( :id => '-1' )
     end
  end

  def update
    @member = Member.find(current_user.credentials_id)

    if @member.update(member_post_params)
      impressionist(@member, 'lid bewerkt')
    
      redirect_to users_root_path
    end    
  end
  
  def add_funds
    member = Member.find(current_user.credentials_id)
    
    balance = CheckoutBalance.find_by_member_id!(member.id)
    
    if balance.nil?
      flash[:notice] = I18n.t('failed', scope: 'activerecord.errors.models.ideal_transaction')
      redirect_to users_root_url
    end
    
    ideal = IdealTransaction.new( 
      :description => "Checkout #{member.name}",
      :amount => params[:amount],
      :issuer => params[:bank],
      :type => 'MONGOOSE',
      :member => @member, 
      :transaction_id => balance.id, 
      :transaction_type => 'CheckoutBalance' )

    if ideal.save
      redirect_to ideal.url
      return
    else
      flash[:notice] = I18n.t('failed', scope: 'activerecord.errors.models.ideal_transaction')
      redirect_to users_root_url
    end
  end
  
  def confirm_add_funds    
    ideal = IdealTransaction.find_by_uuid(params[:uuid])

    if ideal.status == 'SUCCESS'
      transaction = CheckoutTransaction.new( :price => params[:amount], :checkout_balance => ideal.transaction_id )
      transaction.save

      ideal.update_attribute(:transaction_id, ideal.id)
      ideal.save

      flash[:notice] = I18n.t('success', scope: 'activerecord.errors.models.ideal_transaction')
    else
      flash[:notice] = I18n.t('failed', scope: 'activerecord.errors.models.ideal_transaction')
    end

    redirect_to users_root_url
  end
  
  private
  def member_post_params
    params.require(:member).permit(:first_name,
                                   :infix,
                                   :last_name,
                                   :address,
                                   :house_number,
                                   :postal_code,
                                   :city,
                                   :phone_number,
                                   :email,
                                   :gender,
                                   :birth_date)
  end
  
  def set_locale
    session['locale'] = params[:l] || session['locale'] || I18n.default_locale
    I18n.locale = session['locale']
  end
end