class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant_id)
    @items = @merchant.items
  end

  def new
    @merchant = Merchant.find(current_user[:merchant_id])
    @item = Item.new
  end

  def create
    @merchant = Merchant.find(current_user[:merchant_id])
    @item = @merchant.items.create(item_params)
    if @item.save
      flash[:notice] = "Your item '#{@item.name}' has been saved"
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render(:new)
    end
  end

  def edit
    @item = Item.find(params[:item_id])
  end

  def status
    @item = Item.find(params[:item_id])
    if params[:activate_or_deactivate] == "deactivate"
      @item.update(active?: false)
      flash[:notice] = "#{@item.name} is no longer for sale"
    elsif params[:activate_or_deactivate] == "activate"
      @item.update(active?: true)
      flash[:notice] = "#{@item.name} is now available for sale"
    end
    redirect_to "/merchant/items"
  end

  def update
    @item = Item.find(params[:item_id])
    if @item.update(item_params) && @item.save
      flash[:notice] = "Your item '#{@item.name}' has been updated"
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:item_id])
    flash[:notice] = "#{item.name} has been deleted"
    item.destroy
    redirect_to "/merchant/items"
  end

  private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end
end
