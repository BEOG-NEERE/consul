class Users::SessionsController < Devise::SessionsController

  private

    def after_sign_in_path_for(resource)
      if !verifying_via_email? && resource.show_welcome_screen? && !override?
        welcome_path
      else
        super
      end
    end

    def override?
      Setting["feature.user.override_verification"] == 'active'
    end

    def after_sign_out_path_for(resource)
      request.referer.present? ? request.referer : super
    end

    def verifying_via_email?
      return false if resource.blank?
      stored_path = session[stored_location_key_for(resource)] || ""
      stored_path[0..5] == "/email"
    end

end
