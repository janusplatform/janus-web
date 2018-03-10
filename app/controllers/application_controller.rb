class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :ic_handler

  layout :determine_layout


  def determine_layout
    if intercooler.request?
      "application_no_header"
    else
      "application"
    end
  end

  def intercooler
    @intercooler_support ||= IntercoolerSupport.new(self)
  end

  def ic_handler
    begin
      intercooler.before_request
      yield
      intercooler.after_request
    rescue Exception => e
      raise e
    end
  end

  def order_direction
    params[:oa].blank? ? :desc : :asc
  end


end
