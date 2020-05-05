require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils
    .secure_compare(
      ::Digest::SHA256.hexdigest(username),
      ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])
      ) &
      ActiveSupport::SecurityUtils
      .secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"])
      )
  end
  mount Sidekiq::Web, at: "/sidekiq"
  mount API::SslTestProgram => '/'
end
