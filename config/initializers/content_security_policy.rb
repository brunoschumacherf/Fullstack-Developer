# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data, :blob
    policy.object_src  :none
    policy.script_src  :self, :unsafe_inline
    policy.style_src   :self, :unsafe_inline
    policy.connect_src :self, :https, :wss, :ws
    policy.frame_ancestors :none

    if Rails.env.development?
      vite = "http://#{ViteRuby.config.host_with_port}"
      policy.script_src :self, :unsafe_inline, :unsafe_eval, vite
      policy.connect_src :self, :https, :wss, :ws, vite, "ws://#{ViteRuby.config.host_with_port}"
    end
  end
end
