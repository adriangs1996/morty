# frozen_string_literal: true

RSpec.describe Mortymer::Endpoint do # rubocop:disable Metrics/BlockLength
  describe "#generate_parameters" do # rubocop:disable Metrics/BlockLength
    context "when input class implements json_schema" do
      let(:endpoint) do
        described_class.new(
          http_method: :get,
          input_class: QueryParamsInput,
          output_class: TestOutput,
          name: "API::V1::TestEndpoint"
        )
      end

      it "uses json_schema to generate parameters" do
        parameters = endpoint.send(:generate_parameters)

        expect(parameters).to contain_exactly(
          {
            name: :name,
            in: "query",
            schema: { type: "string" },
            required: true
          },
          {
            name: :age,
            in: "query",
            schema: { type: "integer" },
            required: false
          }
        )
      end
    end

    context "when input class does not implement json_schema" do
      let(:endpoint) do
        described_class.new(
          http_method: :get,
          input_class: SimpleQueryParamsInput,
          output_class: TestOutput,
          name: "API::V1::TestEndpoint"
        )
      end

      it "uses Dry::Swagger to generate parameters" do
        parameters = endpoint.send(:generate_parameters)

        expect(parameters).to contain_exactly(
          {
            name: :email,
            in: "query",
            schema: { type: :string, "x-nullable": false },
            required: true
          },
          {
            name: :active,
            in: "query",
            schema: { type: :boolean, "x-nullable": false },
            required: true
          }
        )
      end
    end

    context "when http method is not GET or DELETE" do
      let(:endpoint) do
        described_class.new(
          http_method: :post,
          input_class: QueryParamsInput,
          output_class: TestOutput,
          name: "API::V1::TestEndpoint"
        )
      end

      it "returns empty array" do
        expect(endpoint.send(:generate_parameters)).to eq([])
      end
    end

    context "when input_class is nil" do
      let(:endpoint) do
        described_class.new(
          http_method: :get,
          input_class: nil,
          output_class: TestOutput,
          name: "API::V1::TestEndpoint"
        )
      end

      it "returns empty array" do
        expect(endpoint.send(:generate_parameters)).to eq([])
      end
    end
  end
end
