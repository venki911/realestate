class DashboardsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_before_action :block_invalid_user!
  def index

  end
  
  def blocked
  end
end