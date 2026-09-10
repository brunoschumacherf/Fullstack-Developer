admin = User.find_or_initialize_by(email_address: "admin@example.com")
admin.assign_attributes(
  full_name: "Ada Admin",
  password: "password123",
  password_confirmation: "password123",
  role: :admin,
  avatar_url: "https://ui-avatars.com/api/?name=Ada+Admin&background=4f46e5&color=fff"
)
admin.save!

member = User.find_or_initialize_by(email_address: "user@example.com")
member.assign_attributes(
  full_name: "Morgan Member",
  password: "password123",
  password_confirmation: "password123",
  role: :member,
  avatar_url: "https://ui-avatars.com/api/?name=Morgan+Member&background=0f766e&color=fff"
)
member.save!

puts "Contas criadas:"
puts "  Admin  admin@example.com / password123"
puts "  Usuário   user@example.com  / password123"
