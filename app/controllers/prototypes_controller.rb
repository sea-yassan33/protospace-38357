class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:edit]
  before_action :corrent_user, only: [:edit]
  before_action :move_to_index, except: [:index, :show]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to prototypes_path
    else
      @prototype = Prototype.new(prototype_params)
      render 'new'
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
   
    if @prototype.update(prototype_params)
      redirect_to action: :show
    else
      render 'edit'
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to prototypes_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
  
  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end 

  def corrent_user
    @prototype = Prototype.find(params[:id])
    @user = @prototype.user
    unless @user == current_user
      redirect_to(prototypes_path)
    end
  end
end
