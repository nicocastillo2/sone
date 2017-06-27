class SuscriptionsController < ApplicationController
  before_action :set_payment

  def edit
    
  end

  def update
    
  end


  private

  def set_payment
    @payment = current_user.payment
  end

end
