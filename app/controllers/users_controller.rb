class UsersController < ApplicationController
  def index
    render json: User.all
  end

  # GET /api/users/:id
  def show
    user = User.find_by(id: params[:id])
    if user
      render json: {user: UserSerializer.new(user)}, status: :ok
    else
      render json: {error: "User not found"}, status: :not_found
    end
  end

  # POST /api/users
  def create
    @user = User.create(user_params)

    if @user
      render json: {user: UserSerializer.new(@user)}, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/users/:id
  def update
    if @user.update(user_params)
      render json: {user: UserSerializer.new(@user)}, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/users/:id
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def user_params
    params.permit(:name)
  end
end
