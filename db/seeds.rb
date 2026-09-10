User.destroy_all

admin = User.create!(
  full_name: "Admin Master",
  email_address: "admin@admin.com",
  password: "password123",
  password_confirmation: "password123",
  role: :admin
)

member = User.create!(
  full_name: "Usuário Comum",
  email_address: "user@user.com",
  password: "password123",
  password_confirmation: "password123",
  role: :member
)

puts "Seeds executados com sucesso!"
puts "Admin: admin@admin.com | Senha: password123"
puts "User: user@user.com   | Senha: password123"