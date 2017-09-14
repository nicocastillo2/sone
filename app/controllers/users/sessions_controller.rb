class Users::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    until current_user.payment.cycle_start <= DateTime.now && DateTime.now <= current_user.payment.cycle_end
      end_date = current_user.payment.cycle_end
      current_user.payment.update(cycle_start: DateTime.now, cycle_end: DateTime.now.next_month)
      current_user.update(available_emails: 100)
    end
    campaigns_path
  end

  def after_sign_out_path_for(resource_or_scope)
   	response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    Rails.cache.clear
    root_path
  end
  
end