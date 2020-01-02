class User < ActiveRecord::Base
    validates :first_name, :last_name, :email, :password, :sector, presence: true
    validates :email, uniqueness: true
end

class Post < ActiveRecord::Base
    validates :content, length: {minimum: 1}
end