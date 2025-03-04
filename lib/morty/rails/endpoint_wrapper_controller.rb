# frozen_string_literal: true

module Morty
  module Rails
    # This controller acts as a wrapper for Morty endpoints, handling param conversion
    # and response rendering
    class EndpointWrapperController < ::ActionController::API
      rescue_from Dry::Struct::Error, with: :handle_invalid_params
      rescue_from Dry::Types::CoercionError, with: :handle_invalid_params

      # This method should be used when inheriting from a Controller
      def execute
        endpoint_class = request.env["morty.endpoint_class"]
        dispatch_action_to(self, endpoint_class.action, endpoint_class.input_class)
      end

      def handle
        endpoint_class = request.env["morty.endpoint_class"]
        controller_class = endpoint_class.controller_class
        handler = controller_class.new
        dispatch_action_to(handler, endpoint_class.action, endpoint_class.input_class)
      end

      private

      def action_params
        p = params.to_unsafe_h.to_h.deep_transform_keys(&:to_sym)
        p.delete(:controller)
        p.delete(:actioncontroller)
        p
      end

      def dispatch_action_to(controller, method, input_class)
        input = input_class.new(action_params)
        output = controller.send(method, input)
        render json: output.to_h, status: :ok
      end

      def handle_invalid_params(error)
        render json: { error: "Validation Failed", details: error.message }, status: :unprocessable_entity
      end
    end
  end
end
