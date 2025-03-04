# frozen_string_literal: true

require "spec_helper"
require "mortymer/utils/string_transformations"

RSpec.describe Mortymer::Utils::StringTransformations do # rubocop:disable Metrics/BlockLength
  describe ".underscore" do # rubocop:disable Metrics/BlockLength
    subject { described_class.underscore(string) }

    context "when string is nil" do
      let(:string) { nil }
      it { is_expected.to be_nil }
    end

    context "when string is empty" do
      let(:string) { "" }
      it { is_expected.to eq "" }
    end

    context "when string is already underscored" do
      let(:string) { "already_underscored" }
      it { is_expected.to eq "already_underscored" }
    end

    context "when string contains camelCase" do
      let(:string) { "camelCase" }
      it { is_expected.to eq "camel_case" }
    end

    context "when string contains PascalCase" do
      let(:string) { "PascalCase" }
      it { is_expected.to eq "pascal_case" }
    end

    context "when string contains module separators" do
      let(:string) { "Module::SubModule::Class" }
      it { is_expected.to eq "module/sub_module/class" }
    end

    context "when string contains acronyms" do
      let(:string) { "APIController" }
      it { is_expected.to eq "api_controller" }
    end

    context "when string contains mixed cases and separators" do
      let(:string) { "API::V1::UserProfileController" }
      it { is_expected.to eq "api/v1/user_profile_controller" }
    end

    context "when string contains hyphens" do
      let(:string) { "some-hyphenated-string" }
      it { is_expected.to eq "some_hyphenated_string" }
    end
  end
end
