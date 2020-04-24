class MemosController < ApplicationController
  def index
    @memos = Memo.all
  end

  def new
    @memo = Memo.new
  end

  def create
    @memo = Memo.new(memo_params)
    if @memo.save
      flash[:notice] = "Note créée avec succès !"
      redirect_to home_path
    else
      render :new
    end
  end

  def edit
    @memo = Memo.find(params[:id])
  end

  def update
    @memo = Memo.find(params[:id])
    if @memo.update(memo_params)
      if params[:memo][:done] == "true"
        flash[:notice] = "Tâche effectuée !"
        redirect_to home_path
      else
        flash[:notice] = "Note modifiée avec succès !"
        redirect_to home_path
      end
    else
      render :edit
    end
  end

  def destroy
    @memo = Memo.find(params[:id])
    @memo.destroy
    flash[:notice] = "Note supprimée avec succès !"
    redirect_to home_path
  end

  private

  def memo_params
    params.require(:memo).permit(:description, :date, :categorie, :done)
  end
end
