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
          if customer.subscription.status == "active" && @suscriptions.index(new_suscription) > @suscriptions.index(current_user.payment.plan_name)
            customer.subscription.cancel
            current_user.payment.update(upgrade: true)
            subscription = customer.create_subscription({
              :plan => new_suscription
            })
          elsif customer.subscription.status == "canceled" && @suscriptions.index(new_suscription) > @suscriptions.index(current_user.payment.plan_name)
            current_user.payment.update(upgrade: true)
            subscription = customer.create_subscription({
              :plan => new_suscription
            })
          else
            subscription = customer.subscription.update({
              :plan => new_suscription
            })
          end
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

    begin
      CampaignMailer.change_subscription(new_suscription.capitalize, current_user.email).deliver_now
    rescue SparkPostRails::DeliveryException => e
      p e
    end
    flash[:success] = t("controllers.suscriptions_controller.upgrade_notice")
    redirect_to campaigns_path
  end

  private

  def require_payment_method
    unless current_user.payment.id_conekta || current_user.payment.card_conekta
      flash[:info] = t("controllers.suscriptions_controller.payment_method_notice")
      redirect_to new_payment_path
    end
  end

end
