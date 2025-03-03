# frozen_string_literal: true

module Morty
  module Rails
    # This controller acts as a wrapper for Morty endpoints, handling param conversion
    # and response rendering
    class EndpointWrapperController < ::ActionController::Base
      rescue_from Dry::Struct::Error, with: :handle_invalid_params
      rescue_from Dry::Types::CoercionError, with: :handle_invalid_params

      def handle
        byebug
        endpoint_class = request.env["morty.endpoint_class"]
        controller_class = endpoint_class.controller_class
        # If the controller is using Morty::DependenciesDsl this
        # should fire the Dependency Injection Engine
        handler = controller_class.new

        # Build input from params
        input_class = endpoint_class.input_class
        input = input_class.new(action_params)

        # Call the endpoint
        output = handler.send(endpoint_class.action, input)

        # Render the response
        render json: output.to_h, status: :ok
      end

      private

      def action_params
        p = params.to_unsafe_h.to_h.deep_transform_keys(&:to_sym)
        p.delete(:controller)
        p.delete(:actioncontroller)
        p
      end

      def handle_invalid_params(error)
        render json: { error: "Validation Failed", details: error.message }, status: :unprocessable_entity
      end
    end
  end
end
