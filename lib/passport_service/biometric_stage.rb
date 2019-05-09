module PassportService
  class BiometricStage < Stage
    def step
      3
    end

    def time_range
      5..7
    end
  end
end
