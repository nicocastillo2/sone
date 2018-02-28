lorem = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sit amet efficitur nulla, eu commodo ex. Quisque luctus magna ut massa",
"ed varius ante viverra. Aenean rutrum justo sed dolor lacinia, eu vehicula sem blandit. In purus lectus, scelerisque eu est ut, eleifend placerat",
"Phasellus suscipit dolor nunc, non gravida quam malesuada sed. Mauris pretium lacus euismod sodales tristique. Pellentesque eget elementum tortor.",
"Cras eget sapien et diam bibendum fermentum. Phasellus vehicula tortor at finibus venenatis. Aliquam nec pharetra arcu, et auctor felis.",
"Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
"Aliquam efficitur venenatis elit, sit amet mattis dui tincidunt eu. Ut eget nibh vulputate, facilisis ex a, feugiat lacus.",
"Phasellus sagittis, nunc non efficitur congue, libero risus tristique sapien, sed consectetur metus turpis id diam. Sed bibendum tincidunt nibh",
"Aliquam bibendum turpis vel lorem mollis congue. Nulla ut lobortis velit. Etiam euismod ligula massa", 
"Non mattis lectus rutrum nec. Aenean turpis leo, dignissim a interdum vitae, pellentesque a est. Maecenas fringilla nisi sit amet lobortis",
"Sagittis id imperdiet ac, viverra elementum risus.",
"Nullam a diam in tortor laoreet scelerisque sit amet tristique nisl. Integer rhoncus sodales orci, ut condimentum ipsum semper ac.",
"Duis sit amet rutrum mi. Mauris porttitor sed nisi sit amet feugiat. Fusce diam tellus, pharetra sed dui vitae, egestas tristique tellus.",
"Suspendisse quis ipsum non lorem interdum malesuada aliquam pellentesque nisi. Nunc viverra bibendum dapibus. Donec ullamcorper lectus lectus",
"In sed consectetur urna. Aenean quis eros dictum, laoreet diam non, gravida justo.",
"Duis convallis mattis convallis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.",
"Quisque condimentum mattis enim, dignissim volutpat ante volutpat ac. Morbi mollis auctor suscipit.",
"Mauris interdum lacus in justo porttitor, eget viverra sem lacinia. Ut quis est non velit fermentum elementum quis ut mi. Morbi non pulvinar lectus.",
"Nullam at ante sapien. Quisque vitae risus auctor, volutpat erat et, sollicitudin sem. Aliquam tincidunt ex facilisis magna ultrices blandit.",
"Nunc sit amet urna tellus. Maecenas sollicitudin mi dui, sit amet mollis magna auctor vel."]


detractor =  [0, 1, 2, 3, 4, 5, 6]
promotor = [9, 10]  
normal =  [7, 8]

c = Campaign.find 3



c.contacts.each do |contact|  
  value = rand
  
  if value < 0.55
    score = promotor.sample
  elsif value < 0.85
    score = normal.sample
  else
    score = detractor.sample
  end
  
  Answer.create({ contact_id: contact.id, score: score, comment: lorem.sample })
end

