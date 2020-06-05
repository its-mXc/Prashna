module Admin
  class UsersController < AdminController

    before_action :set_user, only: [:show, :disable]
    before_action :user_not_disabled, only: [:disable]

    def index
      @users = User.user
    end

    def show

    end

    def disable
      @user.disabled = true
      if @user.save
        redirect_to admin_users_path, notice: "User disabled"
      else
        redirect_to admin_users_path, notice: "User could not be disabled"
      end
        
    end

    def refund
      payment_transaction = PaymentTransaction.find_by(id: params[:payment_transaction_id])
      payment_transaction.refund!
      redirect_to admin_user_path(payment_transaction.user), notice: "Payment transaction refunded"
    end

    private def set_user
      @user = User.find_by(id: params[:id])
      unless @user
        redirect_to admin_users_path, notice: "cannot find user"
      end
    end

    private def user_not_disabled
      if @user.disabled
        redirect_to admin_users_path, notice: "Already disabled"
      end
    end
    
  end
end