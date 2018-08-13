module Admin
  class DashboardController < BaseController
    skip_load_and_authorize_resource

    def index
      @daemon_statuses = Global.daemon_statuses
      @currencies_summary = Currency.all.map(&:summary)
      @register_count = Member.count
      @deposits_all = Deposit.group("DATE(created_at)").count("DATE(created_at)").to_json
      @withdraws_all = Withdraw.group("DATE(created_at)").count("DATE(created_at)").to_json
      @pending_deposit = Deposit.where(:aasm_state => 'submitting').count()
      @pending_withdraw = Withdraw.where(:aasm_state => 'submitting').count()
      @verification_request = IdDocument.where(:aasm_state => 'unverified').count()
      @unverified_user = IdDocument.where(:aasm_state => 'unverified').count()
    end
  end
end
