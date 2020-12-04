# frozen_string_literal: true

module HasActive
  extend ActiveSupport::Concern
  included do
    enum status: %i[active inactive]
  end
end
