class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new,:create]
  before_action :find_group
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user
    if @post.save
      redirect_to group_path(@group)
    else
      render 'new'
    end
  end

  def edit
    @post= Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success]='Post updated'
      redirect_to account_posts_path
    else
      flash[:danger]='Something wrong'
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to account_posts_path
  end



  private
  def find_group
    @group = Group.find(params[:group_id])
  end

  def post_params
    params.require(:post).permit(:content)
  end

end
