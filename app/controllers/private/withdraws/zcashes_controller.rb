module Private::Withdraws
  class ZcashesController < ::Private::Withdraws::BaseController
    include ::Withdraws::Withdrawable
  end
end
