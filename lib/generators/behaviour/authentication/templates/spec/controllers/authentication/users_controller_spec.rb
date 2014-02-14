require "spec_helper"

describe Authentication::UsersController do
  context "when I am not signed in" do
    describe "GET new" do
      before(:each) { get :new }

      it { expect(response).to be_successful }
    end

    describe "POST create" do
      context "when I submit valid data" do
        before(:each) { post :create, email: "valid@email.com", password: "password" }

        it { expect(response).to redirect_to root_path }
        it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_signed_up")) }
        it("signs me in") { expect(cookies[:user_id]).to eq(User.find_by_email("valid@email.com").id) }
      end
    end

    describe "GET edit" do
      before(:each) { get :edit }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.unauthenticated_user")) }
    end

    describe "PUT update" do
      before(:each) { put :update }

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.unauthenticated_user")) }
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

      it { expect(response).to be_successful }
    end

    describe "PUT update" do
      context "when I submit valid data" do
        before(:each) { put :update, password: "new_password", current_password: "password" }

        it { expect(response).to be_successful }
        it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_updated_account")) }
      end
    end
  end
end
