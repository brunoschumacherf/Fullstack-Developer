# frozen_string_literal: true

require "json"

unless defined?(RubyVM::ZJIT) && RubyVM::ZJIT.enabled?
  abort "ZJIT is disabled. Run Ruby with --zjit-stats=/dev/null."
end

unless RubyVM::ZJIT.stats_enabled?
  abort "Extended ZJIT statistics are disabled. Run Ruby with --zjit-stats=/dev/null."
end

iterations = Integer(ENV.fetch("ZJIT_PROFILE_ITERATIONS", 500))
users = User.order(:id).limit(100).to_a

Rails.application.eager_load!
RubyVM::ZJIT.reset_stats!

started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

iterations.times do
  Dashboard::Stats.call
  users.each { |user| UserSerializer.new(user).as_json }
end

elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at
stats = RubyVM::ZJIT.stats
summary_keys = %i[
  compiled_iseq_count
  failed_iseq_count
  compile_time_ns
  code_region_bytes
  total_mem_bytes
  side_exit_count
  zjit_insn_count
  vm_insn_count
  ratio_in_zjit
]

puts JSON.pretty_generate(
  ruby: RUBY_DESCRIPTION,
  iterations: iterations,
  users_per_iteration: users.length,
  elapsed_seconds: elapsed.round(4),
  zjit: ENV["ZJIT_PROFILE_FULL"] == "true" ? stats : stats.slice(*summary_keys)
)
