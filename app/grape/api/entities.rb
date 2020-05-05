module API
  module Entities
    class API::Entities::DomainEntity < Grape::Entity
      expose :id
      expose :name
      expose :state
    end
  end
end
