class AnswersController < ApplicationController

  def new
    id = CampaignsHelper.decrypt(params[:data])
    contact = Contact.find(id)
    Campaign.increment_counter(:new_answers, contact.campaign.id)
    @score = params[:score]
    @answer = Answer.create(score: @score, contact: contact)
  end

  def update
    answer = Answer.find(params[:id])
    answer.update(comment: params[:answer][:comment])
    redirect_to root_path
  end

end
