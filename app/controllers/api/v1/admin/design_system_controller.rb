module Api
  module V1
    module Admin
      class DesignSystemController < ApplicationController
        before_action :authenticate_user!
        before_action :require_admin!

        def index
          render file: 'public/design_system/index.html', layout: false
        end

        private

        def require_admin!
          unless current_user.admin?
            render json: { error: 'Not authorized' }, status: :unauthorized
          end
        end
      end
    end
  end
end
