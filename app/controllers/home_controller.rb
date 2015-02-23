class HomeController < ApplicationController
  layout 'home'

  skip_before_action :authenticate_user!
  skip_before_action :block_invalid_user!

end