module Admin
  class UsersQuery
    DEFAULT_PER_PAGE = 10
    MAX_QUERY_LENGTH = 100

    attr_reader :query, :page, :per_page, :total, :total_pages

    def initialize(params:, scope: User.all, per_page: DEFAULT_PER_PAGE)
      @query = params[:query].to_s.strip.first(MAX_QUERY_LENGTH)
      @per_page = per_page
      @scope = filter(scope.order(:full_name))
      @total = @scope.count
      @total_pages = [ (@total.to_f / @per_page).ceil, 1 ].max
      @page = params.fetch(:page, 1).to_i.clamp(1, @total_pages)
    end

    def records
      @scope.offset((page - 1) * per_page).limit(per_page)
    end

    def pagination
      { page: page, per_page: per_page, total: total, total_pages: total_pages }
    end

    private

    def filter(scope)
      return scope if query.blank?

      name_matches = scope.where("full_name ILIKE ?", "%#{User.sanitize_sql_like(query)}%")
      email_match = User.find_by(email_address: query.downcase)
      return name_matches unless email_match

      scope.where(id: name_matches.select(:id)).or(scope.where(id: email_match.id))
    end
  end
end
