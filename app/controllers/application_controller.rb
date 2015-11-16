class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_filter :check_login

    def check_login
        if session[:linkedin_token] == nil || session[:linkedin_pin] == nil
            redirect_to :login
        end
    end

end
