module PassportService
  class Stage
    attr_accessor :current_token, :max_agents, :free_agents, :step

    def initialize(max_agents)
      @max_agents = max_agents
      @current_token = nil
      @free_agents = max_agents
    end

    def process_applicant(a)
      a.current_step = self.step
      self.free_agents -= 1
      a.processing_time += self.time_range.to_a.sample
    end
  end
end
