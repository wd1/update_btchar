module Admin
  class TradeHistoryController < BaseController
    skip_load_and_authorize_resource

    def index
      # @daemon_statuses = Global.daemon_statuses
      # @currencies_summary = Currency.all.map(&:summary)
      # @register_count = Member.count
      @trade_history = Trade.all
    end
  end
end
