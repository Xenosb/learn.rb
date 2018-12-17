class LandingController < ApplicationController
  def index
    @dog_breed = 'Irish Setter'
    @result = 2 * 2
  end
end
