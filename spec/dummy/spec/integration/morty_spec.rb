# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Morty modules are loaded" do
  it "has Morty module loaded" do
    expect(defined?(Morty)).to eq("constant")
  end

  it "has Morty::DependenciesDsl loaded" do
    expect(defined?(Morty::DependenciesDsl)).to eq("constant")
  end

  it "has loaded the Morty::EndpointRegistry" do
    expect(defined?(Morty::EndpointRegistry)).to eq("constant")
  end
end
