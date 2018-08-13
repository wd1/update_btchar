module Private
  module Deposits
    class ZcashesController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlCoinable
    end
  end
end
