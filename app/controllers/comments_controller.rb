class CommentsController < ApplicationController
  before_action :set_post, only: [:create]

  def index
    render json: Comment.all
  end

  # POST /api/posts/:post_id/comments
  def create
    return if performed? # Stop if set_post rendered a 404

    @comment = @post.comments.create!(comment_params)
    # @comment.user = User.find_or_create_by(name: params[:name]) if params[:name].present?

    if @comment.save
      render json: {comment: CommentSerializer.new(@comment)}, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    comment = comment.find_by(id: params[:id])
    if comment
      render json: {comment: CommentSerializer.new(comment)}, status: :ok
    else
      render json: {error: comment.errors.full_messages}, status: :not_found
    end
  end

  def update
    comment = Comment.find_by(id: params[:id])
    if comment.update(comment_params)
      render json: {comment: CommentSerializer.new(comment)}, status: :created
    else
      render json: {error: comment.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id])
    if comment
      comment.destroy
      head :no_content
    else
      render json: {errors: comment.errors.full_messages}, status: :not_found
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end

  def comment_params
    params.permit(:body, :post_id, :user_id) # Adjusted to match Postman parameters
  end
end