module PassportService
  class Applicant
    attr_accessor :token, :current_waiting_time, :processing_time, :current_step

    def initialize(token)
      @token = token
      @current_waiting_time = 0 # minutes
      @processing_time = 0 # minutes
      @current_step = 0 # in reception
    end
  end
end
