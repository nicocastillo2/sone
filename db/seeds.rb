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
    contact = Contact.create(name: "Contact #{contact_num + 1}",
                   email: "contact_#{contact_num + 1}@mail.com",
                   sent_date: nil,
                   status: status,
                   campaign: campaign)
    Answer.create(score: rand(1..10),
                  comment: "Answer of contact #{contact_num + 1}",
                  contact: contact)
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

puts '1 campaign created for Admin with 15 contacts added to it and every
contact created an answer'
