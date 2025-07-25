# class CommentsController < ApplicationController
#   before_action :set_comment, only: %i[ show edit update destroy ]

#   # GET /comments or /comments.json
#   def index
#     @comments = Comment.all
#   end

#   # GET /comments/1 or /comments/1.json
#   def show
#   end

#   # GET /comments/new
#   def new
#     @comment = Comment.new
#   end

#   # GET /comments/1/edit
#   def edit
#   end

#   # POST /comments or /comments.json
#   def create
#     @comment = @post.comments.build(comment_params)
#     @comment.user = User.find_or_create_by(name: params[:user_name]) if params[:user_name].present?

#     if @comment.save
#       render json: CommentSerializer.new(@comment), status: :created
#     else
#       render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
#     end
#   end

#   # PATCH/PUT /comments/1 or /comments/1.json
#   def update
#     respond_to do |format|
#       if @comment.update(comment_params)
#         format.html { redirect_to @comment, notice: "Comment was successfully updated." }
#         format.json { render :show, status: :ok, location: @comment }
#       else
#         format.html { render :edit, status: :unprocessable_entity }
#         format.json { render json: @comment.errors, status: :unprocessable_entity }
#       end
#     end
#   end

#   # DELETE /comments/1 or /comments/1.json
#   def destroy
#     @comment.destroy!

#     respond_to do |format|
#       format.html { redirect_to comments_path, status: :see_other, notice: "Comment was successfully destroyed." }
#       format.json { head :no_content }
#     end
#   end

#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_comment
#       @comment = Comment.find(params.expect(:id))
#     end

#     # Only allow a list of trusted parameters through.
#     def comment_params
#       params.permit(:body, :post_id)
#     end
# end


class CommentsController < ApplicationController
  before_action :set_post, only: [:create]

  def index
    render json: Comment.all
  end

  # POST /api/posts/:post_id/comments
  def create
    return if performed? # Stop if set_post rendered a 404

    @comment = @post.comments.create!(comment_params)
    @comment.user = User.find_or_create_by(name: params[:name]) if params[:name].present?

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