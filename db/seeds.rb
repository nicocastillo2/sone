@user = User.create(username: 'test',
                    email: 'test@mail.com',
                    password: 'testkh',
                    password_confirmation: 'testkh')

puts '1 User created'

@admin = AdminUser.create(username: 'admin',
                          email: 'admin@mail.com',
                          password: 'adminkh',
                          password_confirmation: 'adminkh')

AdminUser.create(username: 'nico',
                 email: 'nico@mail.com',
                 password: 'nico12345',
                 password_confirmation: 'nico12345')

puts '2 Admin User created'

5.times do |campaign_num|
  color = '#' + "%06x" % (rand * 0xffffff)
  status = rand(0..1)
  campaign = Campaign.create(name: "Campaign #{campaign_num + 1}",
                             sender_name: @user.username,
                             sender_email: @user.email,
                             logo: 'Logo',
                             color: color,
                             user: @user)
  15.times do |contact_num|
    days_before = contact_num % 3
    contact = Contact.create(name: "Contact #{contact_num + 1}",
                   email: "contact_#{contact_num + 1}@mail.com",
                   sent_date: nil,
                   status: status,
                   campaign: campaign)
    Answer.create(score: rand(1..10),
                  comment: "Answer of contact #{contact_num + 1}",
                  contact: contact,
                  created_at: Time.now - days_before.days)
  end
end

puts '5 campaigns created for User with 15 contacts added to each campaign and
every contact created an answer'

color = '#' + "%06x" % (rand * 0xffffff)
admin_campaign = Campaign.create(name: 'Admin Campaign',
                                 sender_name: @admin.username,
                                 sender_email: @admin.email,
                                 logo: 'Logo',
                                 color: color,
                                 user_id: @admin.id)
15.times do |contact_num|
  status = rand(0..1)
  contact = Contact.create(name: "Contact #{contact_num + 1}",
                           email: "contact_#{contact_num + 1}@mail.com",
                           sent_date: nil,
                           status: status,
                           campaign: admin_campaign)
  Answer.create(score: rand(1..10),
                comment: "Answer of contact #{contact_num + 1}",
                contact: contact)
end



roberto = AdminUser.create(username: 'roberto',
                          email: 'roberto@kheper.io',
                          password: '123456',
                          password_confirmation: '123456')

campaign = Campaign.create(name: "Kheper",
                             sender_name: "Roberto",
                             sender_email: "roberto@kheper.io",
                             logo: 'Logo',
                             color: 'red',
                             user: roberto)

mails = ["roberto@kheper.io", "mauricio@kheper.io", "alejandro@kheper.io"]
mails.each_with_index do |mail, index|
  contact = Contact.create(name: "Kheper #{index}",
                             email: mail,
                             sent_date: nil,
                             status: "not_sent",
                             campaign: campaign)
end

puts '1 campaign created for Admin with 15 contacts added to it and every
contact created an answer'
