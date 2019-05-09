module PassportService
  class DocumentStage < Stage
    def step
      1
    end

    def time_range
      5..15
    end
  end
end
