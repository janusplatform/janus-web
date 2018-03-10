class DesktopController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :guest]

  def index
    if current_user
      redirect_to :action => :home and return
    end
  end


  def home

  end


end