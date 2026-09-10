InertiaRails.configure do |config|
  config.version = ViteRuby.digest
  config.encrypt_history = true
  config.always_include_errors_hash = true
  config.use_script_element_for_initial_page = true
  config.use_data_inertia_head_attribute = true
  config.ssr_enabled = ENV["INERTIA_SSR"] == "true"
  config.ssr_url = ENV.fetch("INERTIA_SSR_URL", "http://127.0.0.1:13714")
end
