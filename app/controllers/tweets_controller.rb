class TweetsController < ApplicationController
  before_action :authenticate_user!
  def index
      @tweets = Tweet.all
      @tweets = Tweet.all.order(created_at: :desc)

      if params[:latest]
          @tweets = Tweet.latest
      elsif params[:old]
          @tweets = Tweet.old
      elsif params[:most_favorited]
          @tweets = Tweet.most_favorited
      else
          @tweets = Tweet.all
      end

      if params[:tag]
          Tag.create(name: params[:tag])
      end

      @tags = Tag.all
      @tweets = Tweet.where("name LIKE ? OR graduation LIKE ? OR title LIKE ? OR date LIKE ? OR about LIKE ? OR username LIKE ? OR overall LIKE ? OR level LIKE ?", '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%') if params[:search].present?
      #もしタグ検索したら、tweet_idsにタグを持ったidをまとめてそのidで検索
      if params[:tag_ids].present?
          tweet_ids = []
          params[:tag_ids].each do |key, value| 
          if value == "1"
              Tag.find_by(name: key).tweets.each do |p| 
                  tweet_ids << p.id
              end
          end
      end
          tweet_ids = tweet_ids.uniq
          #キーワードとタグのAND検索
          @tweets = @tweets.where(id: tweet_ids) if tweet_ids.present?
      end

      @tag = Tag.select("name", "id")
      tag_search = params[:tag_search]
      if tag_search != nil
          @tweets = Tag.find_by(id: tag_search).tweets
      end

      @tweets = Kaminari.paginate_array(@tweets).page(params[:page]).per(5)
  end

  def new
      @tweet = Tweet.new
  end

  def create
      tweet = Tweet.new(tweet_params)
      tweet.user_id = current_user.id
      if tweet.save
          redirect_to :action => "index" 
      else
          redirect_to :action => "new"
      end
  end

  def show
      @tweet = Tweet.find(params[:id])
      
      @comments = @tweet.comments
      @comment = Comment.new 
  end

  def edit
      @tweet = Tweet.find(params[:id])
  end

  def update
      tweet = Tweet.find(params[:id])
      if tweet.update(tweet_params)
          redirect_to :action => "show", :id => tweet.id
      else
          redirect_to :action => "new"
      end
  end

  def destroy
      tweet = Tweet.find(params[:id])
      tweet.destroy
      redirect_to action: :index
  end

  private
  
  def tweet_params
      params.require(:tweet).permit(:name, :graduation, :title, :date, :about, :username, :overall, :level, tag_ids: [])
  end
end