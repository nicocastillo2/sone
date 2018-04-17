class Users::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    until current_user.payment.cycle_start <= DateTime.now && DateTime.now <= current_user.payment.cycle_end
      end_date = current_user.payment.cycle_end
      current_user.payment.update(cycle_start: DateTime.now, cycle_end: DateTime.now.next_month)
      # if current_user.payment.card_conekta.nil?
        current_user.update(available_emails: 100)
        current_user.payment.update(plan_name: "freelance")
      # else
        # case current_user.payment.plan_name
          # when "freelance"
            # emails_limit = 100
          # when "startup"
            # emails_limit = 1000
          # when "crecimiento"
            # emails_limit = 5000
          # when "enterprise"
            # emails_limit = 10000
        # end
        # current_user.update(available_emails: emails_limit)
      # end
    end
    campaigns_path
  end

  def after_sign_out_path_for(resource_or_scope)
   	response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    Rails.cache.clear
    root_path
  end

  def admin
    @users = User.all
  end
  
end