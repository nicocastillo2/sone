require 'faker'

@user = AdminUser.create(username: 'test',
                    email: 'test@mail.com',
                    password: 'testkh',
                    password_confirmation: 'testkh')

puts '1 User created'

@admin = AdminUser.create(username: 'admin',
                          email: 'admin@mail.com',
                          password: 'adminkh',
                          password_confirmation: 'adminkh')

User.create(username: 'nico',
                 email: 'nico@mail.com',
                 password: 'nico12345',
                 password_confirmation: 'nico12345')

puts '2 Admin User created'

campaign_logo_img = Rails.root.join("app/assets/images/logo-sone-250.png").open

5.times do |campaign_num|
  color = '#' + "%06x" % (rand * 0xffffff)
  status = rand(0..1)
  campaign = Campaign.create(name: "Campaign #{campaign_num + 1}",
                             sender_name: @user.username,
                             sender_email: 'test',
                             logo: campaign_logo_img,
                             color: color,
                             last_sent: Time.now,
                             user: @user)
  15.times do |contact_num|
    days_before = contact_num % 30
    contact = Contact.create(name: "Contact #{contact_num + 1}",
                   email: "contact_#{contact_num + 1}@mail.com",
                   sent_date: Time.now,
                   status: status,
                   campaign: campaign,
                   valid_info: true)
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
                                 sender_email: 'admin',
                                 logo: campaign_logo_img,
                                 color: color,
                                 last_sent: Time.now,
                                 user_id: @admin.id)
15.times do |contact_num|
  status = rand(0..1)
  contact = Contact.create(name: "Contact #{contact_num + 1}",
                           email: "contact_#{contact_num + 1}@mail.com",
                           sent_date: Time.now,
                           status: status,
                           campaign: admin_campaign,
                           valid_info: true)
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
                             logo: campaign_logo_img,
                             color: 'red',
                             last_sent: Time.now,
                             user: roberto)

mails = ["roberto@kheper.io", "mauricio@kheper.io", "alejandro@kheper.io"]
mails.each_with_index do |mail, index|
  contact = Contact.create(name: "Kheper #{index}",
                             email: mail,
                             sent_date: Time.now,
                             status: "not_sent",
                             campaign: campaign,
                             valid_info: true)
end

puts '1 campaign created for Admin with 15 contacts added to it and every
contact created an answer'

# Uncomment just to add some answers to campaign 2 for testing purposes
# 15.times do |contact_num|
#   status = rand(0..1)
#   contact = Contact.create(name: "Contact #{contact_num + 100}",
#                  email: "contact_#{contact_num + 1}@mail.com",
#                  sent_date: Time.now,
#                  status: status,
#                  campaign_id: 2,
#                  valid_info: true)
#   Answer.create(score: rand(1..10),
#                 comment: "ADDED Answer of contact #{contact_num + 100}",
#                 contact: contact,
#                 created_at: Time.now - 3.months)
# end

# Campaign with all necessary and correct data to test
color = '#' + "%06x" % (rand * 0xffffff)

full_campaign = Campaign.create(name: "Full",
                                sender_name: @user.username,
                                sender_email: 'mau',
                                logo: campaign_logo_img,
                                color: color,
                                tmp_topics: ["brand", "city", "office", "product", "sku"],
                                last_sent: Time.now,
                                user: @user)

# mau = Contact.create(name: 'Mauricio',
#                      email: 'mauricio@kheper.io',
#                      sent_date: Time.now,
#                      status: rand(0..1),
#                      campaign: full_campaign,
#                      topics: {"sku"=>"196908", "city"=>"Dionysus M", "brand"=>"Prodder", "office"=>"Schaefer Group", "product"=>"Nugget Nectar"},
#                      valid_info: true)
# roberto = Contact.create(name: 'Roberto',
#                          email: 'roberto@kheper.io',
#                          sent_date: Time.now,
#                          status: rand(0..1),
#                          topics: {"sku"=>"296908", "city"=>"Dionysus R", "brand"=>"Prodder", "office"=>"Schaefer Group", "product"=>"Nugget Nectar"},
#                          campaign: full_campaign,
#                          valid_info: true)
# aldo = Contact.create(name: 'Aldo',
#                       email: 'aldo@kheper.io',
#                       sent_date: Time.now,
#                       status: rand(0..1),
#                       campaign: full_campaign,
#                       topics: {"sku"=>"996908", "city"=>"Dionysus A", "brand"=>"Prodder", "office"=>"Schaefer Group", "product"=>"Nugget Nectar"},
#                       valid_info: true)
# jonathan = Contact.create(name: 'Jonathan',
#                       email: 'jonathan@kheper.io',
#                       sent_date: Time.now,
#                       status: rand(0..1),
#                       campaign: full_campaign,
#                       topics: {"sku"=>"496908", "city"=>"Dionysus J", "brand"=>"Prodder", "office"=>"Schaefer Group", "product"=>"Nugget Nectar"},
#                       valid_info: true)

# Answer.create(score: rand(1..10),
#               comment: 'Mau answer',
#               contact: mau)
# Answer.create(score: rand(1..10),
#               comment: 'Roberto answer',
#               contact: roberto)
# Answer.create(score: rand(1..10),
#               comment: 'Aldo answer',
#               contact: aldo)
# Answer.create(score: rand(1..10),
#               comment: 'Jonathan answer',
#               contact: jonathan)

200.times do |contact_num|
  # status = rand(0..1)
  contact = Contact.create(name: "Contact #{contact_num + 1}",
                           email: "contact_#{contact_num + 1}@mail.com",
                           sent_date: Time.now,
                           status: 1,
                           campaign: full_campaign,
                           topics: {
                                    "sku" => Faker::Number.number(6),
                                    "city" => Faker::Ancient.god,
                                    "brand" => Faker::App.name,
                                    "office" => Faker::Company.name,
                                    "product" => Faker::Beer.name
                                   },
                           valid_info: true)
  # if status == 1
    Answer.create(score: rand(1..10),
                  comment: "Answer of contact #{contact_num + 1}",
                  contact: contact,
                  created_at: Time.now - rand(1..300).days)
  # end
end
