module Managers
  class BaseController < Api::V1::BaseController
    before_action :authorize_manager!

    private

    def authorize_manager!
      authenticate_user!
      authorize! :manage
    end
  end
end
