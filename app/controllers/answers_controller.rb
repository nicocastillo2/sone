class AnswersController < ApplicationController

  def new
    id = CampaignsHelper.decrypt(params[:data])
    contact = Contact.find(id)
    Campaign.increment_counter(:new_answers, contact.campaign.id)
    @score = params[:score]
    @answer = Answer.new(score: @score, contact: contact)

    if DateTime.now - 48.hours > contact.sent_date
      @status = 'expired'
    elsif Answer.find_by_contact_id(@answer.contact_id)
      @status = 'answered'
    else
      @answer = Answer.create(score: @score, contact: contact)
    end
  end

  def update
    answer = Answer.find(params[:id])
    answer.update(comment: params[:answer][:comment])
    # redirect_to new_answer_url(data: params[:data])
    #se soluciona cambiando a root_path
    render :new, locals: {status: "expired"}
  end

end
