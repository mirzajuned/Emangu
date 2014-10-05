class Api::BaseController < ApplicationController
  #before_filter :authenticate_user!
  respond_to :json

  rescue_from Exception, with: :generic_exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  private


  def permission_denied
    render json: {error: 'unauthorized'}, status: :unauthorized
  end

  def record_not_found(error)
    respond_to do |format|
      format.json { render :json => {:error => error.message}, :status => 404 }
    end
  end

  def generic_exception(error)
    respond_to do |format|
      format.json { render :json => {:error => error.message}, :status => 500 }
    end
  end

end
