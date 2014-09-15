class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :published, :unpublished, :update, :destroy]
  before_action :authenticate_user!, :except =>[:index, :show]

  # GET /posts
  def index
    @posts = Post.published
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    redirect_to @post, notice: 'Not an authorized user'  if !@post.users_post(current_user)
  end

  # POST /posts
  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  def blog_posts
    @posts = current_user.posts
  end

  def published
    if @post.users_post(current_user)
      @post.publish!
      redirect_to blog_posts_posts_path, notice: 'Post was successfully published.'
    else
      redirect_to @post, notice: 'Not an authorized user' 
    end
  end

  def unpublished
    if @post.users_post(current_user)
      @post.unpublish!
      redirect_to blog_posts_posts_path, notice: 'Post was successfully unpublished.'
    else
      redirect_to @post, notice: 'Not an authorized user' 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :body, :published_at)
    end
end
