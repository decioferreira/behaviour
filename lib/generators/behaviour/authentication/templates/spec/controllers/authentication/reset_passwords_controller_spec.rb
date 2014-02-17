require "spec_helper"

describe Authentication::ResetPasswordsController do
  context "when I am successfully registered" do
    let!(:user) { User.create(email: "valid@email.com", password: "validpassword") }

    describe "GET new" do
      before(:each) { get :new }

      it { expect(response).to be_successful }
      it { expect(response).to render_template(:new) }
    end

    describe "POST create" do
      let(:mailer) { double(:mailer).as_null_object }

      before(:each) do
        allow(AuthenticationMailer).to receive(:reset_password).with(user).and_return(mailer)
        post :create, email: "valid@email.com"
      end

      it { expect(response).to be_successful }
      it { expect(response).to render_template(:new) }
      it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_sent_reset_password_email")) }

      it { expect(assigns(:user).reset_password_token).not_to be_nil }
      it("sends a password reset email") { expect(mailer).to have_received(:deliver) }
    end
  end

  context "when I am have a valid reset password token" do
    let!(:user) { User.create(email: "valid@email.com", password: "validpassword", reset_password_token: "validtoken") }

    describe "GET edit" do
      context "when I access with a valid token" do
        before(:each) { get :edit, token: "validtoken" }

        it { expect(response).to be_successful }
        it { expect(response).to render_template(:edit) }
      end

      context "when I access with an invalid token" do
        before(:each) { get :edit, token: "invalid" }

        it { expect(response).to redirect_to reset_password_path }
        it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.invalid_reset_password_token")) }
      end

      context "when I access with no token" do
        before(:each) { get :edit }

        it { expect(response).to redirect_to reset_password_path }
        it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.no_reset_password_token")) }
      end
    end

    describe "PUT update" do
      context "when I access with a valid data" do
        before(:each) { put :update, password: "new_password", token: "validtoken" }

        it { expect(response).to be_successful }
        it { expect(response).to render_template(:edit) }
        it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_reset_password")) }
        it { expect(assigns(:user).password).to eq("new_password") }
      end

      context "when I access with an invalid token" do
        before(:each) { put :update, password: "new_password", token: "invalid" }

        it { expect(response).to redirect_to reset_password_path }
        it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.invalid_reset_password_token")) }
      end

      context "when I access with no token" do
        before(:each) { put :update, password: "new_password" }

        it { expect(response).to redirect_to reset_password_path }
        it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.no_reset_password_token")) }
      end
    end
  end

  context "when I am signed in" do
    let(:user) { User.create(email: "valid@email.com", password: "validpassword") }
    before(:each) { cookies[:user_id] = user.id }

    describe "GET new" do
      before(:each) { get :new }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.authenticated_sign_out_try_again")) }
    end

    describe "POST create" do
      before(:each) { post :create }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.authenticated_sign_out_try_again")) }
    end

    describe "GET edit" do
      before(:each) { get :edit }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.authenticated_sign_out_try_again")) }
    end

    describe "PUT update" do
      before(:each) { put :update }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.authenticated_sign_out_try_again")) }
    end
  end
end
