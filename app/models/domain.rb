class Domain < ApplicationRecord
  validates_uniqueness_of :name

  include AASM

  aasm column: :state, whiny: false do
    state :broken, initial: true
    state :working

    event :two_weeks do
      transitions from: :working, to: :broken, guard: :working?
    end
    event :one_week do
      transitions from: :working, to: :broken, guard: :working?
    end
    event :set_expired do
      transitions from: :working, to: :broken, guard: :working?
    end
    event :set_ssl_error do
      transitions from: :working, to: :broken, guard: :working?
    end
    event :set_connection_error do
      transitions from: :working, to: :broken, guard: :working?
    end
    event :set_working do
      transitions from: :broken, to: :working, guard: :broken?
    end
  end
end
