# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"

# Meta scope /complex-doctors/<name>
module ComplexDoctors
  extend Morty::PathDslMixin
  path_suffix :name

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
    const :date, Date
  end

  # /complex-doctors/<name>/get-appointments/<date>
  class GetAppointments < Morty::Service
    path_suffix :date
    I = type_member { { fixed: DoctorsParams } }

    sig { override.params(params: DoctorsParams).returns(AppointmentsResponse) }
    def call(params)
      AppointmentsResponse.new(
        doctor: params.name,
        appointments: [Appointment.new(date: params.date, capacity: 2)]
      )
    end
  end
end

RSpec.describe("Endpoint with added prefix to path") do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  it "should require the path prefix to be present" do
    get "/complex-doctors/get-appointments"
    expect(last_response.status).to eq(404)
  end

  it "should allow path-prefix paths" do
    get "/complex-doctors/jekyll/get-appointments/2024-01-01"
    expect(last_response.status).to eq(200)
  end

  it "should return json response with jekyll as name" do
    get "/complex-doctors/jekyll/get-appointments/2024-01-01"
    response = JSON.parse(last_response.body)
    expect(response["doctor"]).to eq("jekyll")
    expect(response["appointments"].first["date"]).to eq("2024-01-01")
  end
end
