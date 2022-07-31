class MessageGenerator
  MESSAGE_TYPES = {
    late_ticket: "late_ticket",
    send_estimation: "send_estimation",
  }

  class << self
    def generate type, params = {}
      content = File.open("./message_templates/#{type}.txt", "r"){|f| f.readlines.join("")}
      
      case type
      when :late_ticket
        errors = validate_params_for_late_ticket params

        unless errors.empty?
          puts errors.join("\n") 
          return nil
        end

        return content.gsub(":member_names", params[:member_names])
          .gsub(":late_reason", params[:late_reason])
          .gsub(":late_hours", params[:late_hours])
          .gsub(":new_expect_pr_creation_date", params[:new_expect_pr_creation_date])

      when :send_estimation
        errors = validate_params_for_send_estimation

        unless errors.empty?
          puts errors.join("\n") 
          return nil
        end

        return content.gsub(":member_names", params[:member_names])
          .gsub(":est_time", params[:est_time])
          .gsub(":pr_expect_creation_date", params[:pr_expect_creation_date])
      else
        return nil
      end
    end

    def validate_params_for_late_ticket params
      errors = []
      errors << "Must fill params[:member_names]" if params[:member_names] == nil
      errors << "Must fill params[:late_reason]" if params[:late_reason] == nil
      errors << "Must fill params[:late_hours]" if params[:late_hours] == nil
      errors << "Must fill params[:new_expect_pr_creation_date]" if params[:new_expect_pr_creation_date] == nil
      errors
    end

    def validate_params_for_send_estimation params
      errors = []
      errors << "Must fill params[:member_names]" if params[:member_names] == nil
      errors << "Must fill params[:est_time]" if params[:est_time] == nil
      errors << "Must fill params[:pr_expect_creation_date]" if params[:pr_expect_creation_date] == nil
      errors
    end
  end
end