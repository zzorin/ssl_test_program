require 'sidekiq-scheduler'

class SslCheckWorker
  include Sidekiq::Worker

  def perform
    Domain.find_each do |domain|
      SslChecker.new(domain).check
    end
  end
end
