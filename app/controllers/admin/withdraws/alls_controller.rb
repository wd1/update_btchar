module Admin
  module Withdraws
    class AllsController < ::Admin::Withdraws::BaseController
      load_resource :class => '::Withdraws::All'

      def index
        start_at = DateTime.now.ago(60 * 60 * 24)
        @one_alls = @alls.with_aasm_state(:accepted).order("id DESC")
        @all_alls = @alls.without_aasm_state(:accepted).where('created_at > ?', start_at).order("id DESC")
      end

      def show
        @all = Withdraw.all
      end

      def update
        @all.process!
        redirect_to :back, notice: t('.notice')
      end

      def destroy
        @all.reject!
        redirect_to :back, notice: t('.notice')
      end
    end
  end
end
