# frozen_string_literal: true
class GenericWorkToShareJSONService
  attr_reader :work, :document, :delete

  def initialize(work, opts = {})
    @work = work
    @document = ShareNotify::PushDocument.new(work.url)
    @delete = opts.fetch(:delete, false)
  end

  def json
    document.title = work.title.first
    document.updated = work.date_modified
    add_contributors_to_document
    return false unless document.valid?
    document.delete if delete
    document.to_share.to_json
  end

  private

    def add_contributors_to_document
      work.creator.each do |creator|
        document.add_contributor(name: creator, email: email_for_name(creator))
      end
    end

    def email_for_name(name)
      value = NameDisambiguationService.new(name).disambiguate
      value.blank? ? "" : value[0][:email]
    end
end
