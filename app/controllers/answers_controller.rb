class AnswersController < ApplicationController

  def new
    contact = Contact.find_by token: params[:token]
    @answer = Answer.create(score: params[:score], contact: contact)
    contact.update(token: nil)
  end

  def update
    answer = Answer.find(params[:id])
    answer.update(comment: params[:answer][:comment])
    redirect_to root_path
  end

end
