module Admin
  class PendingDepositsController < BaseController
    skip_load_and_authorize_resource

    def index
      # @daemon_statuses = Global.daemon_statuses
      # @currencies_summary = Currency.all.map(&:summary)
      # @register_count = Member.count
      @all = Deposit.all
    end
  end
end
