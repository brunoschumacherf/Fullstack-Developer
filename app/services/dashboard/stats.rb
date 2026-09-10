module Dashboard
  class Stats
    def self.call
      counts = User.group(:role).count
      {
        total_users: User.count,
        role_counts: {
          "admin" => counts["admin"].to_i,
          "member" => counts["member"].to_i
        }
      }
    end
  end
end
