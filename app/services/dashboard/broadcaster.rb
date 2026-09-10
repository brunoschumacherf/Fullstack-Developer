module Dashboard
  class Broadcaster
    STATS_STREAM = "admin_dashboard"

    def self.stats
      ActionCable.server.broadcast(STATS_STREAM, Dashboard::Stats.call)
    end

    def self.import_progress(user_import)
      ActionCable.server.broadcast("import_progress_#{user_import.id}", user_import.to_props)
    end
  end
end
