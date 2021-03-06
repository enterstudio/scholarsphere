# frozen_string_literal: true
class BatchEditForm < Sufia::Forms::BatchEditForm
  include WithCleanerAttributes
  def self.build_permitted_params
    super + [:visibility]
  end
end
