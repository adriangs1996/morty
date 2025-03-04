# frozen_string_literal: true

RSpec.describe Mortymer::Container do # rubocop:disable Metrics/BlockLength
  before(:each) do
    # Clear the registry before each test
    described_class.instance_variable_set(:@registry, {})
  end

  describe ".register_constant" do
    it "registers a constant with direct implementation" do
      logger = MyLogger.new
      described_class.register_constant(MyLogger, logger)
      expect(described_class.registry["my_logger"]).to eq(logger)
    end

    it "registers a constant with block implementation" do
      described_class.register_constant(MyLogger) { MyLogger.new }
      expect(described_class.registry["my_logger"]).to be_a(Proc)
    end

    it "converts constant names to container keys correctly" do
      described_class.register_constant("MyApp::UserService", double)
      expect(described_class.registry).to have_key("my_app_user_service")
    end
  end

  describe ".resolve_constant" do # rubocop:disable Metrics/BlockLength
    it "resolves a registered instance" do
      logger = MyLogger.new
      described_class.register_constant(MyLogger, logger)
      expect(described_class.resolve_constant(MyLogger)).to eq(logger)
    end

    it "resolves a registered block" do
      described_class.register_constant(MyLogger) { MyLogger.new }
      expect(described_class.resolve_constant(MyLogger)).to be_a(MyLogger)
    end

    it "caches block resolution results" do
      counter = 0
      described_class.register_constant(MyLogger) do
        counter += 1
        MyLogger.new
      end

      described_class.resolve_constant(MyLogger)
      described_class.resolve_constant(MyLogger)

      expect(counter).to eq(1)
    end

    it "resolves dependencies for classes using DependenciesDsl" do
      described_class.register_constant(Database, Database.new)
      described_class.register_constant(MyLogger, MyLogger.new)

      repo = described_class.resolve_constant(UserRepository)

      expect(repo).to be_a(UserRepository)
      expect(repo.instance_variable_get(:@database)).to be_a(Database)
      expect(repo.instance_variable_get(:@logger_service)).to be_a(MyLogger)
    end

    it "resolves nested dependencies" do
      described_class.register_constant(Database, Database.new)
      described_class.register_constant(MyLogger, MyLogger.new)

      service = described_class.resolve_constant(UserService)

      expect(service).to be_a(UserService)
      expect(service.instance_variable_get(:@user_repository)).to be_a(UserRepository)
      expect(service.instance_variable_get(:@email_service)).to be_a(EmailService)
    end

    it "detects circular dependencies" do
      expect do
        described_class.resolve_constant(CircularA)
      end.to raise_error(Mortymer::Container::DependencyError, /Circular dependency detected/)
    end

    it "raises NotFoundError for unregistered constants" do
      expect do
        described_class.resolve_constant("UnregisteredService")
      end.to raise_error(Mortymer::Container::NotFoundError)
    end
  end
end
