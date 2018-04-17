class StaticController < ApplicationController

  layout "static-layout"
  # http_basic_authenticate_with name: "kheper", password: "1234kh"

  def homepage
    @title="SONE - Software de Experiencia de Cliente" 
    @description="Evalúa la experiencia de tus clientes y encuentra áreas de oportunidad para tu negocio"   
    # redirect_to campaigns_path if user_signed_in?
  end

  def pricing
    @title="SONE - Planes y Precios" 
    @description="Planes que se ajustan a tus necesidades"

  end

  def terms
    @title="SONE - Términos y Condiciones" 
    @description="Conoce nuestros términos y condiciones para la utilización del servicio"

  end

  def politics
    @title="SONE - Política de Privacidad" 
    @description="Acerca de nuestra política de privacidad"

  end
  
  def blog
    byebug
  end
  
end
