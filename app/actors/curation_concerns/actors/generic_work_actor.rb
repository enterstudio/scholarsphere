# frozen_string_literal: true
# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  module Actors
    class GenericWorkActor < CurationConcerns::Actors::BaseActor
      def create(attributes)
        stat = super(attributes)

        # assign again to keep creator order
        curation_concern.creator = attributes[:creator]
        stat
      end
    end
  end
end
