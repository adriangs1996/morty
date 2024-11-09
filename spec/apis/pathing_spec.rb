# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"

class Appointment < T::Struct
  const :date, Date
  const :capacity, Integer
end

class AppointmentsResponse < T::Struct
  const :doctor, String
  const :appointments, T::Array[Appointment]
end

class DoctorsParams < T::Struct
  const :name, String
end

# Meta scope /doctors/<name>
module Doctors
  extend Morty::PathDslMixin
  path_suffix :name

  # /doctors/<name>/get-appointments
  class GetAppointments < Morty::Service
    include Morty::Json
    I = type_member { { fixed: DoctorsParams } }

    sig { override.params(params: DoctorsParams).returns(AppointmentsResponse) }
    def call(params)
      json_bad AppointmentsResponse.new(
        doctor: params.name,
        appointments: [Appointment.new(date: Date.today, capacity: 10)]
      )
    end
  end
end

RSpec.describe("Endpoint with added prefix to path") do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  it "should require the path prefix to be present" do
    get "/doctors/get-appointments"
    expect(last_response.status).to eq(404)
  end

  it "should allow path-prefix paths" do
    get "/doctors/jekyll/get-appointments"
    expect(last_response.status).to eq(400)
  end

  it "should return json response with jekyll as name" do
    get "/doctors/jekyll/get-appointments"
    response = JSON.parse(last_response.body)
    expect(response["doctor"]).to eq("jekyll")
  end
end
