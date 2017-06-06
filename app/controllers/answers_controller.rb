class AnswersController < ApplicationController
  def new
    puts '*' * 30
    puts 'INSIDE NEW'
    @answer = Answer.new
  end

  def create
    puts '*' * 30
    puts 'INSIDE CREATE'
    p params
  end

  private

    def answer_params
      params.require(:answer).permit(:score, :comment)
    end
end
