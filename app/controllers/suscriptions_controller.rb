class SuscriptionsController < ApplicationController
  before_action :require_payment_method, only: "update"
  before_action :require_login

  def index
    @suscriptions = ["freelancer", "startup", "crecimiento", "enterprise"]
    @current_suscription = current_user.payment.plan_name
  end

  def update
    @payment = current_user.payment
    @suscriptions = ["freelancer", "startup", "crecimiento", "enterprise"]
    new_suscription = params[:suscription_name]

    # Mandar error en caso de recibir un parametro mal
    unless @suscriptions.include?(new_suscription)
      flash.now[:warning] = "Se produjo un error"
      render :index and return
    end

    if new_suscription == "freelancer"
      subscription = Conekta::Customer.find(current_user.payment.id_conekta).subscription
      @payment.update(plan_name: "freelancer", cycle_start: DateTime.strptime(subscription.billing_cycle_start.to_s,'%s'),
                      cycle_end: DateTime.strptime(subscription.billing_cycle_end.to_s,'%s'))
      subscription.cancel
    else
      begin
        customer = Conekta::Customer.find(current_user.payment.id_conekta)

        # si existe la subscripcion
        if(customer.subscription)
          customer.subscription.cancel if customer.subscription.status != "active"
          subscription = customer.create_subscription({
            :plan => new_suscription
          })
        else
          subscription = customer.create_subscription({
            :plan => new_suscription
          })
        end
        @payment.update(plan_name: new_suscription,
                        cycle_start: DateTime.strptime(subscription.billing_cycle_start.to_s,'%s'),
                        cycle_end: DateTime.strptime(subscription.billing_cycle_end.to_s,'%s'))
      rescue Conekta::Error => e
        flash.now[:danger] = e.message
        render :index and return
      end
    end
    CampaignMailer.change_subscription(new_suscription.capitalize, current_user.email).deliver_now
    flash[:success] = "Se realizó su cambio de suscripción a: #{new_suscription.capitalize}"
    redirect_to campaigns_path
  end

  private

  def require_payment_method
    redirect_to new_payment_path unless current_user.payment.id_conekta
  end

end
