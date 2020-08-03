class EncouragementsController < ApplicationController
  def new
    @encouragement = Encouragement.new
  end

  def create
    @encouragement = Encouragement.new(encouragement_params)
    if @encouragement.save
      flash[:notice] = "Merci pour ton message ❤️"
      redirect_to encouragement_path(@encouragement)
    else
      render :new
    end
  end

  def show
    @encouragement = Encouragement.find(params[:id])
  end

private

  def encouragement_params
    params.require(:encouragement).permit(:message, :auteur)
  end

end

