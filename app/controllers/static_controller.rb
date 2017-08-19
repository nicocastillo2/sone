class StaticController < ApplicationController

  layout "static-layout"

  def homepage
    redirect_to campaigns_path if user_signed_in?
  end

  def pricing
  end

  def terms
  end

  def politics
  end
end
