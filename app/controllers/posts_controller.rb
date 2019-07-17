class PostsController < ApplicationController

  #layout :layout_or_not
  before_action :authenticate, only: [:destroy, :confirm_destroy]

  def new
    @post = Post.new(author: session[:author])
    flash.now[:notice] = "Pamiętaj o ortografii"
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      session[:author] = @post.author
      flash[:notice] = "Post dodany pomyślnie"
      redirect_to posts_path
    else
      render action: 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:notice] = "Post zaktualizowany pomyślnie."
      redirect_to posts_path
    else
      render action: 'edit'
    end
  end

  def index
    @posts = Post.all
    respond_to do |format|
      format.html { }
      format.xml { }
      format.json { render json: @posts.map { |p| { id: p.id, title: p.title } } }
    end
  end

  def published
    @posts = Post.where(published: true)
    render action: "index"
  end

  def show
    @post = Post.find(params[:id])
  end

  def confirm_destroy
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "Pomyślnie usunięto wpis."
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :author, :body, :published)
  end
  def layout_or_not
    if params[:skip_layout] == "true"
      false
    else
      "jumbotron"
    end
  end
  def authenticate
    authenticate_or_request_with_http_basic "Podaj hasło" do |name, password|
      name == "username" && password == "secret"
    end
  end
end
