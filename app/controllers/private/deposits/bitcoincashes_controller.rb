module Private
  module Deposits
    class BitcoincashesController < ::Private::Deposits::BaseController
      include ::Deposits::CtrlCoinable
    end
  end
end
