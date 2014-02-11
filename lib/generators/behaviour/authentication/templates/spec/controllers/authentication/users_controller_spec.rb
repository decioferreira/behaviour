require "spec_helper"

describe Authentication::UsersController do
  describe "GET new" do
    context "when I am not logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { false }
        get :new
      end

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
      before :each do
        allow(controller).to receive(:signed_in?) { false }
      end

      context "when I submit valid data" do
        before :each do
          allow(controller).to receive(:signed_in?) { false }
          post :create, email: "valid@email.com", password: "password"
        end

        it { expect(response).to redirect_to root_path }
        it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_signed_up")) }

        it "logs me in" do
          expect(User.count).to eq(1)
          expect(session[:user_id]).to eq(User.first.id)
        end
      end
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

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.unauthenticated_user")) }
    end

    context "when I am logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { true }
        get :edit
      end

      it { expect(response).to be_success }
    end
  end

  describe "PUT update" do
    context "when I am not logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { false }
        put :update
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.unauthenticated_user")) }
    end

    context "when I am logged in" do
      let(:user) { User.create(email: "valid@email.com", password: "password") }

      before :each do
        session[:user_id] = user.id
      end

      context "when I submit valid data" do
        before :each do
          put :update, password: "new_password", current_password: "password"
        end

        it { expect(response).to be_success }
        it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_updated_account")) }
      end
    end
  end
end
