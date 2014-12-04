class Api::V1::Users::BaseController < Api::V1::BaseController
  load_and_authorize_resource
end
