class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  # GET /api/posts
  # def index
  #   page = params[:page]&.to_i || 1
  #   per_page = 10
  #   posts = Post.includes(:user).order(created_at: :desc).offset((page - 1) * per_page).limit(per_page)
  #   total_pages = (Post.count.to_f / per_page).ceil
  #   render json: { posts: posts.as_json(include: :user), total_pages: total_pages }
  # end

  def index
   render json: Post.all
  end

  # GET /api/posts/:id
  # def show
  #   # render json: @post.as_json(include: { user: {}, comments: { include: :user } })
  #   post = Post.find_by(id: params[:id])
  #   if post
  #     render json: {post: PostSerializer.new(post)}, status: :ok
  #   else
  #     render json: {error: "This post does not exist"}, status: :not_found
  #   end
  # end

  def show
    render json: {post: PostSerializer.new(@post)}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "This post does not exist" }, status: :not_found
  end

  # POST /api/posts
  def create
    @post = Post.new(post_params)
    @post.user = User.find_or_create_by(name: params[:name]) if params[:name].present?

    if @post.save
      render json: {post: PostSerializer.new(@post)}, status: :ok
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/posts/:id
  def update
    post = Post.find_by(id: params[:id])
    if post.update(post_params)
      render json: {post: PostSerializer.new(post)}, status: :ok
    else
      render json: {error: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/posts/:id
  def destroy
    post = Post.find_by(id: params[:id])
    if post
      post.destroy
      head :no_content
    else
      render json: {errors: post.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:title, :body, :user_id)
  end
end