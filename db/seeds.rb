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
  Campaign.create(name: "Campaign #{campaign + 1}",
                  sender_name: @user.username,
                  sender_email: @user.email,
                  logo: 'Logo',
                  color: color,
                  user_id: @user.id)
end

puts '5 campaigns created for Test'

color = '#' + "%06x" % (rand * 0xffffff)
Campaign.create(name: 'Admin Campaign',
                sender_name: @admin.username,
                sender_email: @admin.email,
                logo: 'Logo',
                color: color,
                user_id: @admin.id)

puts '1 campaigns created for Admin'
