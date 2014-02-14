require "spec_helper"

describe Authentication::ResetPasswordsController do
  context "when I am not signed in" do
    describe "GET new" do
      before(:each) { get :new }

      it { expect(response).to be_successful }
      it { expect(response).to render_template(:new) }
    end

    context "when I am successfully registered" do
      let!(:user) { User.create(email: "valid@email.com", password: "validpassword") }

      let(:mailer) { double(:mailer).as_null_object }
      before(:each) { allow(AuthenticationMailer).to receive(:reset_password).with(user).and_return(mailer) }

      describe "POST create" do
        before(:each) { post :create, email: "valid@email.com" }

        it { expect(response).to be_successful }
        it { expect(response).to render_template(:new) }
        it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_sent_reset_password_email")) }
        it("sends a reset password email") { expect(mailer).to have_received(:deliver) }
      end

      describe "PUT update" do
        before(:each) { put :update }

        it { expect(response).to be_successful }
        it { expect(response).to render_template(:edit) }
        it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_reset_password")) }
      end
    end

    describe "GET edit" do
      before(:each) { get :edit }

      it { expect(response).to be_successful }
      it { expect(response).to render_template(:edit) }
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
