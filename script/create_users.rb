# Run with: bundle exec rails runner script/create_users.rb
require "securerandom"

connection = ActiveRecord::Base.connection
raw_users = connection.select_rows("SELECT id, email_address FROM users")
repaired = 0

raw_users.each do |id, raw_email|
  next if raw_email.to_s.lstrip.start_with?("{")

  encrypted_email = User.type_for_attribute("email_address").serialize(raw_email.to_s.delete("\\"))
  connection.update("UPDATE users SET email_address = #{connection.quote(encrypted_email)} WHERE id = #{Integer(id)}")
  repaired += 1
end

created = 0
100.times do |index|
  number = index + 1
  email = format("usuario%03d@example.com", number)
  user = User.find_or_initialize_by(email_address: email)
  next if user.persisted?

  user.assign_attributes(
    full_name: format("Usuário Exemplo %03d", number),
    password: "password123",
    password_confirmation: "password123",
    role: number.modulo(20).zero? ? :admin : :member
  )
  user.save!
  created += 1
end

puts "#{repaired} e-mails antigos criptografados; #{created} usuários criados; #{User.count} usuários no total."
