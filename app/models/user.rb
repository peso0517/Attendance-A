class User < ApplicationRecord
  # has_many :microposts, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :one_month_attendances
  #dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_tokens
  before_create :create_activation_digest
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true,confirmation: true
  validates :employee_number,  presence: true
  
  require 'csv'
  
  def self.import(file)
    users = []
    #重複id
    overlap_id = []
    CSV.foreach(file.path, headers: true) do |row|

      if exists?(id: row["id"])
        overlap_id.push(row["id"])
        next
      end
      user = new(row.to_hash.slice(*updatable_attributes))
      
      if user.valid?
        users.push(user)
      else
        return "id#{row["id"]}のデータに不備があったため入力失敗しました"
      end
    end
    
    users.each do |user|
      if !user.save
        return "id#{user.id}のデータ保存時にエラーが発生しました"
      end
          # 重複したidがあればメッセージに表示
      return "アップデートが成功しました"
    end
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "name", "email", "affiliation", "employee_number","uid",
     "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior",
     "password"]
  end
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
    
  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

    # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
   # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
    # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
    # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  
  private
  # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end