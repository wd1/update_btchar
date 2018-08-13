module Private::Withdraws
  class UsdtsController < ::Private::Withdraws::BaseController
    include ::Withdraws::Withdrawable
  end
end
