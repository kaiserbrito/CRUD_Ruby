class ProductsController < ApplicationController
  
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  # Method for create new products
  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = 'Product added!'
      redirect_to root_path
    else
      flash[:error] = 'Failed to add the product!'
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(products_params)
      flash[:notice] = 'Product edited!'
      redirect_to root_path
    else
      flash[:notice] = 'Failed to edit.'
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.delete
      flash[:notice] = 'Product deleted!'
      redirect_to root_path
    else
      flash[:notice] = 'Failed to delete.'
      render :destroy
    end
  end

  private
    def product_params
      params.require(:product).permit(:name, :price, :old_price, :short_description, :full_description)
    end
end
