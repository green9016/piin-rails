# frozen_string_literal: true

module HasChecked
  extend ActiveSupport::Concern
  included do
    scope :unchecked, -> { where(checked: false) }
  end
end
