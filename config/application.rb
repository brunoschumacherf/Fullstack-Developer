require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module UserManagementApp
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.i18n.available_locales = %i[pt-BR en]
    config.i18n.default_locale = :"pt-BR"
    config.i18n.fallbacks = [ :"pt-BR", :en ]
    config.generators do |g|
      g.test_framework :rspec, fixtures: true
      g.system_tests :rspec
    end

    config.action_dispatch.default_headers.merge!(
      "X-Content-Type-Options" => "nosniff",
      "Referrer-Policy" => "strict-origin-when-cross-origin"
    )
  end
end
