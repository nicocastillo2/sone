class Answer < ApplicationRecord
  belongs_to :contact

  def self.get_icon num
    case num
    when 0..6
      'frown-o'
    when 7..8
      'meh-o'
    when 9..10
      'smile-o'
    end
  end
end
