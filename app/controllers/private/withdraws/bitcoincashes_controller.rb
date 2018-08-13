module Private
  module Withdraws
    class BitcoincashesController < ::Private::Withdraws::BaseController
      include ::Withdraws::Withdrawable
    end
  end
end
