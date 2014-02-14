require "spec_helper"

describe Authentication::SessionsController do
  context "when I am not signed in" do
    describe "GET new" do
      before(:each) { get :new }

      it { expect(response).to be_successful }
    end

    context "when I am successfully registered" do
      let!(:user) { User.create(email: "valid@email.com", password: "validpassword") }

      describe "POST create" do
        context "when I sign in with a valid email" do
          before(:each) { post :create, email: "valid@email.com", password: "validpassword" }

          it { expect(response).to redirect_to root_path }
          it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_signed_in")) }
          it("signs me in") { expect(cookies[:user_id]).to eq(user.id) }
        end

        context "when I sign in with an invalid email" do
          before(:each) { post :create, email: "invalid@email.com", password: "password" }

          it { expect(response).to be_successful }
          it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.invalid_email")) }
        end

        context "when I sign in with an invalid password" do
          before(:each) { post :create, email: "valid@email.com", password: "invalid" }

          it { expect(response).to be_successful }
          it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.invalid_password")) }
        end
      end
    end

    describe "DELETE destroy" do
      before(:each) { delete :destroy }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_signed_out")) }
    end
  end

  context "when I am signed in" do
    let(:user) { User.create(email: "valid@email.com", password: "validpassword") }
    before(:each) { cookies[:user_id] = user.id }

    describe "GET new" do
      before(:each) { get :new }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.already_authenticated")) }
    end

    describe "POST create" do
      before(:each) { post :create }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.already_authenticated")) }
    end

    describe "DELETE destroy" do
      before(:each) { delete :destroy }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_signed_out")) }
      it("signs me off") { expect(cookies[:user_id]).to be_nil }
    end
  end
end
