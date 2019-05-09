require 'passport_service/base'
require 'passport_service/applicant'
require 'passport_service/stage'
require 'passport_service/document_stage'
require 'passport_service/police_stage'
require 'passport_service/biometric_stage'

module PassportService
  ASSIGNMENT_METHODS = [:token, :time, :random]

  def self.run(params)
    reports = {}

    10.times do |i|
      reports[i] ||= {}

      ASSIGNMENT_METHODS.each do |assignment_meth|
        ps = PassportService::Base.new(assignment_meth, params)
        time_info = ps.process
        reports[i][assignment_meth] = time_info
      end
    end

    puts reports.inspect
  end
end
