class GroupsController < ApplicationController
  before_action :find_group,only: [:show,:edit,:update,:destroy,:join,:quit]
  before_action :authenticate_user!, only: [:new,:create,:edit,:update,:destroy]
  before_action :authenticate_owner!,only:[:edit,:update,:destroy]
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    @posts = @group.posts.recent.paginate(page:params[:page],per_page:5)
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      current_user.join!(@group)
      flash[:succes] = "Group has been created."
      redirect_to group_path(@group)
    else
      flash[:danger] = "something goes wrong."
      render 'new'
    end
  end

  def edit

  end

  def update
    if @group.update(group_params)
      flash[:success] = 'Group has been updated.'
      redirect_to @group
    else
      flash[:danger] = 'Something wrong'
      render 'edit'
    end
  end

  def destroy
    @group.destroy
    flash[:alert]='Group deleted.'
    redirect_to groups_path
  end

  def join
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:success]='Join Group'
    else
      flash[:danger]='You are already a group member.'
    end
    redirect_to group_path(@group)
  end

  def quit
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert]='Quit the group'
    else
      flash[:warning]='You have not yet join the group.'
    end
    redirect_to group_path(@group)
  end


  private
  def group_params
    params.require(:group).permit(:title,:description)
  end
  def find_group
    @group = Group.find(params[:id])
  end
  def authenticate_owner!
    if current_user != @group.user
      redirect_to root_path
      flash[:danger]='You have no permission'
    end
  end

end
