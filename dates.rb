months = [1, 2, 3, 4, 5, 6]
day_31 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
day_30 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
day_28 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]

Answer.all.each do |a|
  month = months.sample
  if month == 1 or month == 3 or month == 5
	day = day_31.sample
  elsif month == 4 or month == 6
    day = day_30.sample
  else
    day = day_28.sample
  end
  a.created_at = Date.new(2017, month, day)
  a.updated_at = Date.new(2017, month, day)
  a.save
end