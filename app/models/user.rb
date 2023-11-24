class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  has_many :comments, dependent: :destroy

  def already_liked?(tweet)
    self.likes.exists?(tweet_id: tweet.id)
  end

  validates :name, presence: true 
  validates :profile, length: { maximum: 200 } 
end
