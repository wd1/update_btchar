module Private
  class HistoryController < BaseController
    skip_before_action :verify_authenticity_token, only: [:sendmail, :sendphonesms]
    helper_method :tabs

    def account
      @market = current_market

      @deposits = Deposit.where(member: current_user).with_aasm_state(:accepted)
      @withdraws = Withdraw.where(member: current_user).with_aasm_state(:done)

      @transactions = (@deposits + @withdraws).sort_by {|t| -t.created_at.to_i }
      @transactions = Kaminari.paginate_array(@transactions).page(params[:page]).per(20)
    end

    def affiliate
      @market = current_market
      @referrals = Member.where(reference_id: current_user.email)
    end

    def trades
      @trades = current_user.trades
        .includes(:ask_member).includes(:bid_member)
        .order('id desc').page(params[:page]).per(20)
    end

    def orders
      @orders = current_user.orders.includes(:trades).order("id desc").page(params[:page]).per(20)
    end

    def sendphonesms
      message = params[:message]
      link = params[:link]
      message << "\nLink:" << link
      phone_number = params[:phone]
      name = params[:name]
      puts message
      authkey = ENV['SMSAUTHKEY']
      sender  = ENV['SENDER']
      route   = ENV['ROUTE']
      country = ENV['COUNTRY']
      params = { :authkey => authkey, :mobiles => phone_number, :message => message, 
                   :sender => sender, :route => route, :country => country }
      puts URI.encode_www_form(params)
      res = Excon.get('http://api.msg91.com/api/sendhttp.php', :query => URI.encode_www_form(params))
      
      #res = Excon.get("http://api.msg91.com/api/sendhttp.php?authkey=188737AzwsuMr0F5a3893b2&mobiles=919999999990&message=Your%20otp%20is%20"+code_value+"&sender=Bitcharge&otp=2786&routes=4&country=0", true)
      puts res.body
      if res.status == 200
        res.body
      else
        Rails.logger.error(res.body)                          
        raise Errors::SMSNotSent, res.body
      end
      
      redirect_to affiliate_history_path
    end

    def sendmail
      name = params[:name]
      message = "Dear"
      message << name << "\n" << params[:message]
      link = params[:link]
      message << "\nLink:" << link
      email = params[:email]
      # url = URI("http://control.msg91.com/api/sendmail.php?body="+message+"&subject=Singup Invitation&to="+params[:email]+"&from=bhuass8@gmail.com&authkey=188737AzwsuMr0F5a3893b2")
      # http = Net::HTTP.new(url.host, url.port)
      
      # request = Net::HTTP::Post.new(url)
      
      # response = http.request(request)
      # puts response.read_body
      # name = params[:name]
      # message = "Dear"
      # message << name << "\n" << params[:message]
      # link = params[:link]
      # message << "\nLink:" << link
      # email = params[:email]
      
      # puts message
      # puts email
      # # puts message
      # # mail(to: email, subject: 'Welcome to My Awesome Site',body: message ,content_type: "text/html")
      # # 
      MemberMailer.set_mail_invite_friend(email, message).deliver
      # TokenMailer.activation(email, 'asdfasdfasdfasdfasdf').deliver
      puts 'asdfvw'
      redirect_to affiliate_history_path
    end
    
    private

    def tabs
      { order: ['header.order_history', order_history_path],
        trade: ['header.trade_history', trade_history_path],
        account: ['header.account_history', account_history_path] }
    end

  end
end
