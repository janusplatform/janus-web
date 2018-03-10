class DesktopController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :guest]

  def index
    unless current_user
      redirect_to :action => :guest and return
    end

  end


  def guest

  end

end