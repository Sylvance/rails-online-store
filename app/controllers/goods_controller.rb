class GoodsController < ApplicationController
    before_action :authorize_access_request!
    before_action :set_good, only: [:show, :update, :destroy]
  
    # GET /goods
    def index
      @goods = current_user.goods
  
      render json: @goods
    end
  
    # GET /goods/1
    def show
      render json: @good
    end
  
    # POST /goods
    def create
      @good = current_user.goods.build(good_params)
  
      if @good.save
        render json: @good, status: :created, location: @good
      else
        render json: @good.errors, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /goods/1
    def update
      if @good.update(good_params)
        render json: @good
      else
        render json: @good.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /goods/1
    def destroy
      @good.destroy
    end
  
    private
  
    def set_good
      @good = current_user.goods.find(params[:id])
    end
  
    def good_params
      params.require(:good).permit(:name)
    end
end
