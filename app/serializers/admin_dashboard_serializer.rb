class AdminDashboardSerializer
  def initialize(current_user:, params:)
    @current_user = current_user
    @users_query = Admin::UsersQuery.new(params: params)
  end

  def as_json
    {
      stats: Dashboard::Stats.call,
      users: @users_query.records.map { |user| UserSerializer.new(user).as_json },
      user_filters: { query: @users_query.query },
      user_pagination: @users_query.pagination,
      active_import: serialize(active_import, UserImportSerializer)
    }
  end

  private

  def active_import
    @current_user.user_imports.where(status: %w[pending processing]).order(created_at: :desc).first
  end

  def serialize(record, serializer)
    serializer.new(record).as_json if record
  end
end
