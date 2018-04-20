class SitemapController < ApplicationController

  def show
    if params[:locale] == "es-MX"
      @links = [ { url: "https://www.sone-app.com/es-MX", priority: 1.00 },
                 { url: "https://www.sone-app.com/es-MX/pricing", priority: 0.80 },
                 { url: "https://www.sone-app.com/blog", priority: 0.80 },
                 { url: "https://www.sone-app.com/es-MX/users/sign_in", priority: 0.80 },
                 { url: "https://www.sone-app.com/es-MX/users/sign_up", priority: 0.80 },
                 { url: "https://www.sone-app.com/es-MX/terms", priority: 0.80 },
                 { url: "https://www.sone-app.com/es-MX/politics", priority: 0.80 }] 
    else
      @links = [ { url: "https://www.sone-app.com/es-ES", priority: 1.00 },
                 { url: "https://www.sone-app.com/es-ES/pricing", priority: 0.80 },
                 { url: "https://www.sone-app.com/blog", priority: 0.80 },
                 { url: "https://www.sone-app.com/es-ES/users/sign_in", priority: 0.80 },
                 { url: "https://www.sone-app.com/es-ES/users/sign_up", priority: 0.80 },
                 { url: "https://www.sone-app.com/es-ES/terms", priority: 0.80 },
                 { url: "https://www.sone-app.com/es-ES/politics", priority: 0.80 }]
    end
  end
  
end
