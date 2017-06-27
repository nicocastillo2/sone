class PaymentsController < ApplicationController
  before_action :set_payment, only: [:destroy]

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # POST /payments
  def create
    # debugger
    # render plain: params.inspect.to_s, layout: false
    user_name = params[:name]
    user_email = current_user.email
    user_phone = params[:phone]
    card_token_id = params[:conektaTokenId]

    customer = Conekta::Customer.create({
      :name => user_name,
      :email => user_email,
      :phone => user_phone,
      :payment_sources => [{
        :token_id => card_token_id,
        :type => "card"
      }]
    })

    @payment = Payment.new(full_name: user_name, phone: user_phone,
                            id_conekta: customer.id,
                            card_conekta: customer.payment_sources.first.id, user: current_user)

    if @payment.save
      redirect_to campaigns_path, notice: 'Se agrego satisfactoriamente el metodo de pago'
    else
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

    customer = Conekta::Customer.find(@payment.id_conekta)
    customer.payment_sources.first.delete
    customer = customer.update({
      :name => user_name,
      :email => user_email,
      :phone => user_phone
    })
    customer.create_payment_source(type: "card", token_id: card_token_id)
    
    debugger


    if @payment.update(full_name: user_name, phone: user_phone, id_conekta: customer.id, card_conekta: customer.payment_sources.first.id, user: current_user)
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])

    end
end
