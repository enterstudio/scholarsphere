# frozen_string_literal: true
class WorkShowPresenter < Sufia::WorkShowPresenter
  include ActionView::Helpers::NumberHelper

  delegate :bytes, to: :solr_document

  self.file_presenter_class = ::FileSetPresenter

  def size
    number_to_human_size(bytes)
  end

  def total_items
    solr_document.fetch('member_ids_ssim', []).length
  end

  # TODO: Remove once https://github.com/projecthydra/sufia/issues/2394 is resolved
  def member_presenters(ids = ordered_ids, presenter_class = composite_presenter_class)
    super.delete_if { |presenter| current_ability.cannot?(:read, presenter.solr_document) }
  end

  def uploading?
    QueuedFile.where(work_id: id).present?
  end

  # Check for member presenters before rendering the representative in CurationConcerns::WorkShowPresenter
  # @ return [FileSetPresenter, NullRepresentativePresenter]
  def representative_presenter
    @representative_presenter ||= build_representative_presenter
  end

  # @return [Array<Hash>] maps a facet's entered value from the user to its cleaned value
  # @example { original_value => cleaned_value }
  def facet_mapping(field)
    config = FieldConfigurator.facet_fields[field]
    send(field).zip(FacetValueCleaningService.call(send(field), config)).to_h
  end

  def permission_badge_class
    PublicPermissionBadge
  end

  private

    # Override to add rows parameter
    # Remove this once we're on the latest CC
    # Also note: https://github.com/projecthydra-labs/hyrax/issues/352
    def file_set_ids
      @file_set_ids ||= begin
                          ActiveFedora::SolrService.query("{!field f=has_model_ssim}FileSet",
                                                          fl: ActiveFedora.id_field,
                                                          rows: 1000,
                                                          fq: "{!join from=ordered_targets_ssim to=id}id:\"#{id}/list_source\"")
                                                   .flat_map { |x| x.fetch(ActiveFedora.id_field, []) }
                        end
    end

    def build_representative_presenter
      return NullRepresentativePresenter.new(current_ability, request) if member_presenters.empty? || representative_id.blank?
      result = member_presenters([representative_id]).first
      return result.representative_presenter if result.respond_to?(:representative_presenter)
      result
    end
end
