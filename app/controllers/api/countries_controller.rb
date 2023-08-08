# frozen_string_literal: true

module Api
  class CountriesController < Api::ApplicationController

    def index
      render json: [{ id: 1, name: 'Spain' }]
    end

    def create
      render json: { id: 1, name: 'Spain' }, status: :created
    end

    def update
      head :no_content
    end

    def destroy
      head :no_content
    end

  end
end
