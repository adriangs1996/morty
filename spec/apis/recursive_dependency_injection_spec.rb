# frozen_string_literal: true
# typed: true

require "rack"
require "rack/test"
require_relative "../schemas/responses"

class User < T::Struct
  const :id, Integer
  const :username, String
  const :email, String
end

module IRepository
  interface!

  sig { abstract.params(id: Integer).returns(T.nilable(User)) }
  def find(id); end
end

module IUnitOfWork
  interface!

  sig { abstract.returns(IRepository) }
  def users; end
end

class UnitOfWork < T::Struct
  include IUnitOfWork
  const :users, IRepository
end

class Repository
  include IRepository

  sig { override.params(id: Integer).returns(T.nilable(User)) }
  def find(id)
    User.new(id: id, username: "test", email: "test@gmail.com")
  end
end

Morty::Dependency.register(IRepository, Repository)
Morty::Dependency.register(IUnitOfWork, UnitOfWork)

# /test-recursive-dependencies/<id>
class TestRecursiveDependenciesService < Morty::Service
  path_suffix :id
  const :unit_of_work, IUnitOfWork

  class Params < T::Struct
    const :id, Integer
  end

  I = type_member { { fixed: Params } }

  sig { override.params(params: Params).returns(T.any(User, Morty::Empty)) }
  def call(params)
    data = unit_of_work.users.find(params.id)
    return Morty::Empty.new if data.nil?

    data
  end
end

RSpec.describe "Test nested DI" do
  T.bind(self, T.untyped)
  include Rack::Test::Methods
  let(:app) { Morty::App.new }

  it "should return 200" do
    get "/test-recursive-dependencies/1"
    expect(last_response.status).to eq(200)
  end
end
