require 'net/http'
module API
  class SslTestProgram < Grape::API
    logger Rails.logger
    format :json

    get :status do
      present Domain.all, with: API::Entities::DomainEntity
    end

    post :domain do
      domain_name = params[:domain_name]
      uri = URI::HTTPS.build(host: domain_name)
      domain = Domain.new(name: uri.host)
      if domain.save
        SslChecker.new(domain).check
      else
        domain.errors.to_json
      end
    end
  end
end
