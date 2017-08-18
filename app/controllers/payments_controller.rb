class PaymentsController < ApplicationController
  before_action :set_payment, only: [:destroy]
  skip_before_action :verify_authenticity_token, only: :payment_callback

  # GET /payments/new
  def new
    @payment = Payment.new
    redirect_to edit_payment_path(current_user.payment) if current_user.payment.card_conekta
  end

  # POST /payments
  def create
    # debugger
    # render plain: params.inspect.to_s, layout: false
    user_name = params[:name]
    user_email = current_user.email
    user_phone = params[:phone]
    card_token_id = params[:conektaTokenId]

    begin
      
      customer = Conekta::Customer.create({
        :name => user_name,
        :email => user_email,
        :phone => user_phone,
        :payment_sources => [{
          :token_id => card_token_id,
          :type => "card"
        }]
      })
      # debugger
      @payment = current_user.payment

      payment_params = {full_name: user_name, phone: user_phone,
                              id_conekta: customer.id,
                              card_conekta: customer.payment_sources.first.id, user: current_user}

    if @payment.update(payment_params)
      redirect_to suscriptions_path, notice: 'Se agrego satisfactoriamente el metodo de pago'
    else
      render :new
    end

    rescue Conekta::ErrorList => e
      errors = []
      for error in e.details do
        errors << error.message
      end
      error_name = errors.inject{ |list, error| list + ", #{error.message}" }

      flash[:danger] = error_name
      render :new
    rescue Conekta::Error => e
      flash[:danger] = "Error Inesperado, intentelo mas tarde"
      render :new
    end

  end

  # PATCH/PUT /payments/1
  def update
    @payment = current_user.payment
    
    user_name = params[:name]
    user_email = current_user.email
    user_phone = params[:phone]
    card_token_id = params[:conektaTokenId]
    update_status = false
    begin

      customer = Conekta::Customer.find(@payment.id_conekta)
      customer.payment_sources.first.delete unless customer.payment_sources.empty?
      customer = customer.update({
        :name => user_name,
        :email => user_email,
        :phone => user_phone
      })
      customer.create_payment_source(type: "card", token_id: card_token_id)
      update_status = @payment.update(full_name: user_name, phone: user_phone, id_conekta: customer.id, card_conekta: customer.payment_sources.first.id, user: current_user)

    # rescue Conekta::ValidationError => e
    #   flash[:danger] = e.message
    rescue Conekta::ErrorList => e
      debugger
      flash[:danger] = e.details[0].message
    rescue Conekta::Error => e
      flash[:danger] = e.message
    end
    
    if update_status
      redirect_to campaigns_path, notice: 'Payment actualisado correctamente.'
    else
      render :edit
    end
  end

  # GET /payments/1/edit
  def edit
    @payment = Payment.find_by_id(params[:id])
    redirect_to new_payment_path unless @payment
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
    redirect_to campaigns_path, notice: 'Payment eliminado correctamente.'
  end

  def payment_callback
    json = JSON.parse(request.body.read)
    puts '*'*100

    if json['type'] == 'subscription.paid'
      id_conekta = json['data']["object"]['customer_id']
      payment = Payment.find_by(id_conekta: id_conekta)
      case payment.plan_name
      when "startup"
        payment.update({available_emails: 1000})
      when "crecimiento"
        payment.update({available_emails: 5000})
      when "enterprise"
        payment.update({available_emails: 10000})
      end
    end
    
    head 200, content_type: "text/html"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end
end
