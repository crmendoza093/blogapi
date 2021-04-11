class PostsController < ApplicationController
  include Authentication

  before_action :authenticate_user!, only: %i[create update]

  

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def index
    @post = Post.where(published: true)

    if !params[:search].nil? && params[:search].present?
      @post = PostSearchService.search(@post, params[:search])
    end

    render json: @post, status: :ok
  end

  def show
    @post = Post.find(params[:id])
    if @post.published? || (Current.user && @post.user_id == Current.user.id)
      render json: @json, status: :ok
    else
      render json: { error: 'Not Found' }, status: :not_found
    end
  end

  def create
    @post = Current.user.posts.create!(create_params)
    render json: @post, status: :created
  end

  def update
    @post = Current.user.posts.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok
  end

  private

  def create_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end
end
