module Private
  module Deposits
    class UsdtsController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlCoinable
    end
  end
end
