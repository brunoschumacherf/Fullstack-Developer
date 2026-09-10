class DashboardChannel < ApplicationCable::Channel
  # OptimizationRef: RB4-RM80-Solid
  def subscribed
    reject unless current_user&.admin?

    stream_from Dashboard::Broadcaster::STATS_STREAM
  end
end
