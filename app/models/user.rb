class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"
    
    attr_accessible :email

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email, :add_subscribe_to_list_mailchimp

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "Travel<br>Shower Kit",
            "class" => "two",
            # "image" =>  ActionController::Base.helpers.asset_path("refer/cream-tooltip@2x.png")
            "image" =>  ActionController::Base.helpers.asset_path("refer/level-1.jpg")
        },
        {
            'count' => 10,
            "html" => "Styling<br>Product",
            "class" => "three",
            # "image" => ActionController::Base.helpers.asset_path("refer/truman@2x.png")
            "image" => ActionController::Base.helpers.asset_path("refer/level-2.jpg")
        },
        {
            'count' => 25,
            "html" => "Complete<br>Kit",
            "class" => "four",
            # "image" => ActionController::Base.helpers.asset_path("refer/winston@2x.png")
            "image" => ActionController::Base.helpers.asset_path("refer/level-3.jpg")
        },
        {
            'count' => 50,
            "html" => "$100 Mister Pompadour<br>Gift Certificate",
            "class" => "five",
            # "image" => ActionController::Base.helpers.asset_path("refer/blade-explain@2x.png")
            "image" => ActionController::Base.helpers.asset_path("refer/level-4.jpg")
        }
    ]

    private

    def create_referral_code
        # binding.pry
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        #binding.pry
        # UserMailer.delay.signup_email(self)
        # UserMailer.test_email(self).deliver
    end


    def do_mailchimp
        gb = Gibbon::API.new("7bab8af62f772b706d6f243f7dc0fbed-us10")
        gb.lists.subscribe({:id => '193ef1abca', 
         :email => {:email => self.email }, :merge_vars => {:REFERRALS => 0},
         :double_optin => false})

        # gb.lists.batch_subscribe(:id => '193ef1abca', :batch => 
        #     [ {:email => {:email => self.email }, :merge_vars => {:FNAME => "FirstName1", :LNAME => "LastName1"}}], :update_existing => true)

    end


    def add_subscribe_to_list_mailchimp
        gb = Gibbon::API.new("7bab8af62f772b706d6f243f7dc0fbed-us10")
        gb.lists.subscribe({:id => '193ef1abca', 
         :email => {:email => self.email }, :merge_vars => {:FNAME => "FirstName1", :LNAME => "LastName1", :REFERRALS => 0},
         :double_optin => false})
    end

    public 
    
    def update_list_mailchimp
        gb = Gibbon::API.new("7bab8af62f772b706d6f243f7dc0fbed-us10")
        gb.lists.batch_subscribe(:id => '193ef1abca', :batch => 
            [ {:email => {:email => self.email }, :merge_vars => { :REFERRALS => self.referrals.count}}], :update_existing => true)
    end
end
