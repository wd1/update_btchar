
module Admin
  module Deposits
    class AllsController < ::Admin::Deposits::BaseController
      load_resource :class => '::Deposits::All'
      load_resource :class => '::Deposits::Argue'
      load_resource :class => '::Deposits::Bank'
      load_resource :class => '::Deposits::Bitcoincash'
      load_resource :class => '::Deposits::Blackcoin'
      load_resource :class => '::Deposits::Dashcoin'
      load_resource :class => '::Deposits::Ether'
      load_resource :class => '::Deposits::Litecoin'
      load_resource :class => '::Deposits::Monero'
      load_resource :class => '::Deposits::Namecoin'
      load_resource :class => '::Deposits::Peercoin'
      load_resource :class => '::Deposits::Realpointcoin'
      load_resource :class => '::Deposits::Ripple'
      load_resource :class => '::Deposits::Satoshi'
      load_resource :class => '::Deposits::Tritiumcoin'
      load_resource :class => '::Deposits::Zcash'
      def index
        start_at = DateTime.now.ago(60 * 60 * 24 * 365)
        @alls = Deposit.all
        @alls = @alls.includes(:member).
          where('created_at > ?', start_at).
          order('id DESC').page(params[:page]).per(20)
        # @argues = @blackcoin.includes(:member).
        #   where('created_at > ?', start_at).
        #   order('id DESC').page(params[:page]).per(20)
      end

      def update
        # @all.accept! if @all.may_accept?
        # redirect_to :back, notice: t('.notice')
      end
    end
  end
end
