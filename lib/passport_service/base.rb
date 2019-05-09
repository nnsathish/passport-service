module PassportService
  class Base

    ALLOWED_PARAMS = {
      max_applicants: 180,
      document_stage_agents: 15,
      police_stage_agents: 10,
      biometric_stage_agents: 12
    }
    attr_reader *ALLOWED_PARAMS.keys
    attr_accessor :assignment_method, :applicants, :stages, :total_processing_time

    # TODO: validate/set max limits
    def initialize(assignment_method, params = {})
      ALLOWED_PARAMS.each do |param, default|
        given_value = params[param]
        self.instance_variable_set("@#{param}".to_sym, given_value || default)
      end
      @assignment_method = assignment_method
      @applicants = []
    end

    def process
      create_applicants
      start_stages
      process_times = {}

      loop do
        stages.each do |stage|
          process_times[stage.step] ||= 0
          while stage.free_agents > 0 do
            a = find_applicant_for(stage)
            process_times[stage.step] += stage.process_applicant(a)
          end
          #update waiting time for other applicants
        end
        all_processed = @applicants.all? { |a| a.current_step == stages.last.step }
        break if all_processed
      end

      process_times
    end

    private

    def create_applicants
      self.max_applicants.times do |i|
        @applicants << Applicant.new(i+1)
      end
    end

    def start_stages
      doc_stage = DocumentStage.new(document_stage_agents)
      police_stage = PoliceStage.new(police_stage_agents)
      biometric_stage = BiometricStage.new(biometric_stage_agents)
      @stages = [doc_stage, police_stage, biometric_stage]
    end

    def find_applicant_for(stage)
      apps = @applicants.select { |a| a.current_step < stage.step }

      case assignment_method
      when :token
        apps.sort_by(&:token)
      when :time
        apps.sort_by(&:current_waiting_time).reverse!
      else # random
        apps.shuffle!
      end
      
      apps.first
    end
  end
end
