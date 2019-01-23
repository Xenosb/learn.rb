class PolynomialsController < ApplicationController
  def show
    @solution = params[:id]
    @solution = Base64.decode64(@solution)
    @solution = Marshal.restore(@solution)
  end

  def new
  end

  def create
    a = params[:a].to_i
    b = params[:b].to_i
    c = params[:c].to_i
    d = params[:d].to_i

    solution = solve(a, b, c, d)
    solution = Marshal.dump(solution)
    solution = Base64.encode64(solution)

    redirect_to "/polynomials/#{solution}"
  end

  private

  def solve(a, b, c, d)
    require 'cmath'

    a = a.to_r
    b = b.to_r
    c = (c - d).to_r

    first = -1 * b
    second = CMath.sqrt(b**2 - 4 * a * c) / (2 * a)

    [first - second, first + second]
  end
end
