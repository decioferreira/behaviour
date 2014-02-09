require 'spec_helper'

describe Authentication::ResetPasswordsController do
  describe "GET new" do
    context "when I am not logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { false }
        get :new
      end

      it { expect(response).to render_template(:new) }
      it { expect(response).to be_success }
    end

    context "when I am logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { true }
        get :new
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.authenticated_sign_out_try_again")) }
    end
  end

  describe "POST create" do
    context "when I am not logged in" do
      let(:mailer) { double(:mailer).as_null_object }
      let!(:user) { User.create(email: "valid@email.com", password: "password") }

      before :each do
        allow(AuthenticationMailer).to receive(:reset_password).and_return(mailer)
        post :create, email: "valid@email.com"
      end

      it { expect(AuthenticationMailer).to have_received(:reset_password).with(user) }
      it { expect(mailer).to have_received(:deliver) }
      it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_sent_reset_password_email")) }
      it { expect(response).to render_template(:new) }
      it { expect(response).to be_success }
    end

    context "when I am logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { true }
        post :create
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.authenticated_sign_out_try_again")) }
    end
  end

  describe "GET edit" do
    context "when I am not logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { false }
        get :edit
      end

      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_success }
    end

    context "when I am logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { true }
        get :edit
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.authenticated_sign_out_try_again")) }
    end
  end

  describe "PUT update" do
    context "when I am not logged in" do
      let!(:user) { User.create(email: "valid@email.com", password: "password") }

      before :each do
        put :update
      end

      it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_reset_password")) }
      it { expect(response).to render_template(:edit) }
      it { expect(response).to be_success }
    end

    context "when I am logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { true }
        put :update
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.authenticated_sign_out_try_again")) }
    end
  end
end
