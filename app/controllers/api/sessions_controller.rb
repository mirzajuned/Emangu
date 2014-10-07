class Api::SessionsController < Devise::SessionsController
  #after_filter :set_csrf_headers, only: [:create, :destroy]
  before_action :warden_authenticate

  def create
    p request.headers['X-XSRF-TOKEN']
    sign_in(resource_name, resource)
    resource.reset_authentication_token!
    render :status => 200, :json => {:success => true, :info => "Logged in", :user => current_user}
  end

  def destroy
    resource=User.where(authentication_token=params[:token])
    resource.clear_authentication_token!

    # warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    # sign_out
    # render nothing: true
  end

  def failure
    render :status => 401, :json => {:success => false, :info => "Login Credentials Failed"}
  end

  def show_current_user
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    render :status => 200, :json => {:success => true, :info => "Current User", :user => current_user}
  end

  def warden_authenticate
    self.resource = warden.authenticate!(auth_options)
  end

  protected

  def set_csrf_headers
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
end
