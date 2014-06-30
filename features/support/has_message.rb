module Capybara
  class Session
    def has_alert_message?(message)
      has_selector?("#alert-message, #notice-message", count: 1) &&
      has_selector?("#alert-message", text: message)
    end

    def has_notice_message?(message)
      has_selector?("#alert-message, #notice-message", count: 1) &&
      has_selector?("#notice-message", text: message)
    end
  end
end
