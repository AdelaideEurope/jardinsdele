class VenteLignesController < ApplicationController
  def index
    @lignesdevente = VenteLigne.all
  end
end
