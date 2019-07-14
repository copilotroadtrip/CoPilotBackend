class WelcomeController < ApplicationController
  def index
    render json:
      {
        'Welcome': 'Welcome to CoPilot Backend.  Rails API for CoPilot - Road trip data consolidated in one application.  For more information on how to use this API, please visit https://github.com/copilotroadtrip/CoPilotBackend'
      }
  end
end
