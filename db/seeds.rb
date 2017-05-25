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

5.times do |campaign|
  color = '#' + "%06x" % (rand * 0xffffff)
  status = rand(0..1)
  campaign = Campaign.create(name: "Campaign #{campaign + 1}",
                             sender_name: @user.username,
                             sender_email: @user.email,
                             logo: 'Logo',
                             color: color,
                             user_id: @user.id)
  15.times do |contact|
    Contact.create(name: "Contact #{contact}",
                   email: "contact_#{contact}@mail.com",
                   sent_date: nil,
                   status: status,
                   campaign: campaign)
  end
end

puts '5 campaigns created for User with 15 contacts added to each campaign'

color = '#' + "%06x" % (rand * 0xffffff)
admin_campaign = Campaign.create(name: 'Admin Campaign',
                                 sender_name: @admin.username,
                                 sender_email: @admin.email,
                                 logo: 'Logo',
                                 color: color,
                                 user_id: @admin.id)
15.times do |contact|
  status = rand(0..1)
  Contact.create(name: "Contact #{contact}",
                 email: "contact_#{contact}@mail.com",
                 sent_date: nil,
                 status: status,
                 campaign: admin_campaign)
end

puts '1 campaign created for Admin with 15 contacts added to it'
