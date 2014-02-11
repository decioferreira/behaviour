require "spec_helper"

describe Authentication::SessionsController do
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
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.already_authenticated")) }
    end
  end

  describe "POST create" do
    context "when I am not logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { false }
      end

      context "when I am successfully registered" do
        let!(:user) { User.create(email: "valid@email.com", password: "validpassword") }

        context "when I sign in with a valid email" do
          before :each do
            post :create, email: "valid@email.com", password: "validpassword"
          end

          it { expect(response).to redirect_to root_path }
          it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_signed_in")) }
          it { expect(session[:user_id]).to eq(user.id) }
        end

        context "when I sign in with an invalid email" do
          before :each do
            post :create, email: "invalid@email.com", password: "password"
          end

          it { expect(response).to be_success }
          it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.invalid_email")) }
        end

        context "when I sign in with an invalid password" do
          before :each do
            post :create, email: "valid@email.com", password: "invalid"
          end

          it { expect(response).to be_success }
          it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.invalid_password")) }
        end
      end
    end

    context "when I am logged in" do
      before :each do
        allow(controller).to receive(:signed_in?) { true }
        post :create
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:alert]).to eq(I18n.t("authentication.alert.already_authenticated")) }
    end
  end

  describe "DELETE destroy" do
    context "when I am not logged in" do
      before :each do
        delete :destroy
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_signed_out")) }
    end

    context "when I am logged in" do
      let!(:user) { User.create(email: "valid@email.com", password: "validpassword") }

      before :each do
        session[:user_id] = user.id
        delete :destroy
      end

      it { expect(response).to redirect_to root_path }
      it { expect(flash[:notice]).to eq(I18n.t("authentication.notice.successfully_signed_out")) }
      it { expect(session[:user_id]).to be_nil }
    end
  end
end
