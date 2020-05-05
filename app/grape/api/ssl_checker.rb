require 'net/http'
module API
  class SslChecker < Grape::API
    logger Rails.logger
    format :json

    get :status do
      present Domain.all, with: API::Entities::DomainEntity
    end

    post :domain do
      # domain_name = "example.com"
      # domain_name = params[:domain_name]
      # uri = URI::HTTPS.build(host: domain_name)
      # domain = Domain.new(name: uri.host)
      # http = Net::HTTP.new(uri.host, uri.port)
      # http.use_ssl = true
      # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      # cert = nil
      # http.start do |h|
      #   cert = h.peer_cert
      # end
      # raise cert.inspect
      domain_name = params[:domain_name]
      uri = URI::HTTPS.build(host: domain_name)
      domain = Domain.new(name: uri.host)
      if domain.save
        SslCheckWorker.perform_async(domain.id)
      else
        domain.errors.to_json
      end
      # raise cert.inspect
      # if Time.now + 2.weeks > cert.not_after
      #   # send reminders
      # end
    end
  end
end
