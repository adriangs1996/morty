# frozen_string_literal: true

RSpec.describe Mortymer::DependenciesDsl do # rubocop:disable Metrics/BlockLength
  describe "class methods" do
    describe ".inject" do
      it "adds dependency to the dependencies list" do
        expect(UserRepository.dependencies).to include(
          { constant: Database, var_name: "database" }
        )
      end

      it "allows custom dependency names" do
        expect(UserRepository.dependencies).to include(
          { constant: MyLogger, var_name: "logger_service" }
        )
      end

      it "infers variable name from constant" do
        expect(EmailService.dependencies).to include(
          { constant: MyLogger, var_name: "my_logger" }
        )
      end
    end

    describe ".dependencies" do
      it "returns the list of dependencies" do
        expect(UserService.dependencies).to contain_exactly(
          { constant: UserRepository, var_name: "user_repository" },
          { constant: EmailService, var_name: "email_service" }
        )
      end
    end
  end

  describe "instance methods" do # rubocop:disable Metrics/BlockLength
    before(:each) do
      Mortymer::Container.register_constant(Database, Database.new)
      Mortymer::Container.register_constant(MyLogger, MyLogger.new)
      Mortymer::Container.register_constant(EmailService) { EmailService.new }
    end

    describe "#initialize" do
      it "injects dependencies on initialization" do
        repo = UserRepository.new
        expect(repo.instance_variable_get(:@database)).to be_a(Database)
        expect(repo.instance_variable_get(:@logger_service)).to be_a(MyLogger)
      end

      it "allows method calls on injected dependencies" do
        repo = UserRepository.new
        result = repo.find_user(1)
        expect(result).to include("SELECT * FROM users WHERE id = 1")
      end

      it "works with nested dependencies" do
        service = UserService.new
        expect(service.instance_variable_get(:@user_repository)).to be_a(UserRepository)
        expect(service.instance_variable_get(:@email_service)).to be_a(EmailService)
      end

      it "maintains dependency chain functionality" do
        service = UserService.new
        result = service.process_user(1)
        expect(result).to eq("Email sent")
      end
    end
  end
end
