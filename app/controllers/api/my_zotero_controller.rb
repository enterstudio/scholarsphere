# frozen_string_literal: true
# This entire file is being overriden for the change mentioned in the TODO below
require 'oauth'

module API
  # Adds the ability to authenticate against Zotero's OAuth endpoint
  class MyZoteroController < ZoteroController
    def callback
      access_token = current_token.get_access_token(oauth_verifier: params['oauth_verifier'])
      # parse userID and API key out of token and store in user instance
      current_user.zotero_userid = access_token.params[:userID]
      current_user.save

      # TODO: we are overriding this entire file to a .user_key on to the end of current_user
      #   This file should be removed once sufia or hyrax have this update and we are on that version
      Sufia::Arkivo::CreateSubscriptionJob.perform_later(current_user.user_key)
      redirect_to sufia.profile_path(current_user), notice: 'Successfully connected to Zotero!'
    rescue OAuth::Unauthorized
      redirect_to sufia.edit_profile_path(current_user.to_param), alert: 'Please re-authenticate with Zotero'
    ensure
      current_user.zotero_token = nil
      current_user.save
    end
  end
end
