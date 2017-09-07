class AnswersController < ApplicationController

  def new
    id = CampaignsHelper.decrypt(params[:data])
    contact = Contact.find(id)
    Campaign.increment_counter(:new_answers, contact.campaign.id)
    @score = params[:score]
    @answer = Answer.new(score: @score, contact: contact)
    @status = false
    puts "psdf"*90
    puts "hola pinche putita"
    if Answer.find_by_contact_id(@answer.contact_id)
      puts "asidasda"* 90
      puts "SI la incluye"
      @status = true
    else
      puts "no no esta"
      @answer = Answer.create(score: @score, contact: contact)
    end
    # Answer.all.each do |ans|
    #   if ans.contact_id == @answer.contact_id
    #     @status = true
    #     return
    #   else
    #     @answer = Answer.create(score: @score, contact: contact)
    #   end
    # end
  end

  def update
    answer = Answer.find(params[:id])
    answer.update(comment: params[:answer][:comment])
    redirect_to root_path
  end

end
