class ApplicationController < ActionController::API
  # For devise
  include ActionController::MimeResponds
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  def render_errors(errors, status = :ok)
    render jsonapi_errors: errors, status: status
  end

  def render_record_invalid(exception)
    # TODO: Should we render a 422 or a 200?
    render_errors exception.record.errors, :unprocessable_entity
  end

  def current_user
    return @user if @user
    # TODO: Does devise-jwt not give us a better way to get the authenticated user?
    token = Warden::JWTAuth::HeaderParser.from_env(request.headers.env)
    payload = Warden::JWTAuth::TokenDecoder.new.call(token)
    @user = Warden::JWTAuth::PayloadUserHelper.find_user(payload)
  end

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:sign_in, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  def success(record, options = {})
    render jsonapi: record, **options
  end
end
