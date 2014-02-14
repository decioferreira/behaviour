class BehaviourController < ApplicationController
  before_filter :signed_in?, only: [:restricted]

  def index
  end

  def restricted
  end

  private def signed_in?
    redirect_to sign_in_path, alert: "Unauthenticated user." unless cookies[:user_id]
  end
end
