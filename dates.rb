months = [7,8,9,10,11,12]
day_31 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
day_30 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
day_28 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]

Campaign.find(2).contacts.each do |c|
  a = c.answer
  month = months.sample
  if month == 7 or month == 8 or month == 10 or month=12
	day = day_31.sample
  elsif month == 9 or month == 11
    day = day_30.sample
  else
    day = day_28.sample
  end
  a.created_at = Date.new(2017, month, day)
  a.updated_at = Date.new(2017, month, day)
  a.save
end