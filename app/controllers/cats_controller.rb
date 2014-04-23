class CatsController < ApplicationController
  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    flash.notice = 'Cat "#{@cat.name}" has been born!'
    @cat.try(:save)
    redirect_to cat_url(@cat)
  end

  def destroy
    @cat = Cat.find(params[:id])
    flash.notice = 'Cat "#{@cat.name}" has been put to rest...'
    @cat.try(:destroy)
    redirect_to cats_url
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])
    @cat.update_attributes(cat_params)

    flash.notice = 'Cat "#{@cat.name}" has been fixed.'
    redirect_to cat_url(@cat)
  end

  private

  def cat_params
    params.require(:cat).permit(:age, :birth_date, :color, :name, :sex)
  end
end
