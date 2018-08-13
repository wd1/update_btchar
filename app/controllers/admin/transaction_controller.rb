module Admin
  class TransactionController < BaseController
    skip_load_and_authorize_resource

    def index
      # @daemon_statuses = Global.daemon_statuses
      # @currencies_summary = Currency.all.map(&:summary)
      # @register_count = Member.count
      @deposit_history = Deposit.all
      @withdraw_history = Withdraw.all
      @trade_history = Trade.all
    end
  end
end
