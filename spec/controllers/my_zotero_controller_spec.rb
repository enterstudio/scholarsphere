# frozen_string_literal: true
require 'rails_helper'

describe API::MyZoteroController, type: :controller do
  let(:user) { create(:user) }
  routes { Sufia::Engine.routes }

  subject { response }


  context 'with an HTTP POST/GET to /api/zotero/callback' do
    context 'with an unauthenticated user' do
      before { get :callback, use_route: :api_zotero_callback }

      specify do
        expect(subject).to have_http_status(302)
        expect(subject).to redirect_to("https://webaccess.psu.edu/?cosign-localhost&https://localhost")
      end
    end

    context 'with a user who is not permitted to make works' do
      before do
        allow_any_instance_of(Ability).to receive(:can?).with(:create, GenericWork).and_return(false)
        sign_in user
        get :callback, use_route: :api_zotero_callback
      end

      specify do
        expect(subject).to have_http_status(302)
        expect(subject).to redirect_to(root_path)
        expect(flash[:alert]).to eq 'You are not authorized to perform this operation'
      end
    end

    context 'with a request lacking an oauth_token' do
      before do
        sign_in user
        get :callback, use_route: :api_zotero_callback
      end

      specify do
        expect(subject).to have_http_status(302)
        expect(subject).to redirect_to(routes.url_helpers.edit_profile_path(user))
        expect(flash[:alert]).to eq 'Malformed request from Zotero'
      end
    end

    context 'with a non-matching token' do
      before do
        sign_in user
        get :callback, use_route: :api_zotero_callback, oauth_token: 'woohoo', oauth_verifier: '12345'
      end

      specify do
        expect(subject).to have_http_status(302)
        expect(subject).to redirect_to(routes.url_helpers.edit_profile_path(user))
        expect(flash[:alert]).to eq 'You have not yet connected to Zotero'
      end
    end

    context 'with a signed-in, valid user' do
      before do
        allow_any_instance_of(User).to receive(:zotero_token) { user_token }
        allow(Sufia::Arkivo::CreateSubscriptionJob).to receive(:perform_later)
        sign_in user
        get :callback, use_route: :api_zotero_callback, oauth_token: token_string, oauth_verifier: pin
      end

      let(:token_string) { 'woohoo' }
      let(:pin) { '12345' }
      let(:user_token) do
        double('token',
               params: { oauth_token: token_string },
               get_access_token: access_token)
      end
      let(:zuserid) { 'myzuser' }
      let(:access_token) do
        double('access', params: { userID: zuserid })
      end

      specify do
        expect(subject).to have_http_status(302)
        expect(Sufia::Arkivo::CreateSubscriptionJob).to have_received(:perform_later).with(user.user_key)
        expect(subject).to redirect_to(routes.url_helpers.profile_path(user))
        expect(flash[:alert]).to be_nil
        expect(flash[:notice]).to eq 'Successfully connected to Zotero!'
        expect(user.reload.zotero_userid).to eq zuserid
      end
    end
  end
end
