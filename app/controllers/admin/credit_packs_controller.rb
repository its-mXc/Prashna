module Admin
  class CreditPacksController < AdminController

    before_action :find_credit_pack, only: [:edit, :update]

    def index
      #FIXME_AB: show enabled or disabled in view
      #FIXME_AB: show button to add new pack
      #FIXME_AB: give option to enable or disable a pack
      @credit_packs = CreditPack.all
    end

    def new
      @credit_pack = CreditPack.new
    end

    def create
      @credit_pack = CreditPack.new(credit_pack_params)

      if @credit_pack.save
        redirect_to admin_credit_packs_path, notice: 'Credit Pack created'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @credit_pack.update(credit_pack_params)
        redirect_to admin_credit_packs_path, notice: "Pack updated"
      else
        render :edit
      end
    end

    private def find_credit_pack
      @credit_pack = CreditPack.find_by(id: params[:id])
      unless @credit_pack
        redirect_to admin_credit_packs_path, notice: "Credit Pack does not exists"
      end
    end

    private def credit_pack_params
      params.require(:credit_pack).permit(:name, :price, :credits, :cover_image, :disabled)
    end
  end
end
