class PageController < ApplicationController

  before_action :authenticate_user!, only: [:page_1, :page_2]
  before_action :set_current_user

  def index
  end

  def open
  end

  def page_1
  end

  def page_2
  end

end
