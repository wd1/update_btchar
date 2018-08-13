class IdentitiesController < ApplicationController
  before_filter :auth_anybody!, only: :new

  def new
    @identity = env['omniauth.identity'] || Identity.new
    @token = Token::ResetPassword.new
  end

  def edit
    @identity = current_user.identity
  end

  def update
    @identity = current_user.identity
    
    unless @identity.authenticate(params[:identity][:old_password])
      redirect_to edit_identity_path, alert: t('.auth-error') and return
    end

    if @identity.authenticate(params[:identity][:password])
      redirect_to edit_identity_path, alert: t('.auth-same') and return
    end

    if @identity.update_attributes(identity_params)
      current_user.send_password_changed_notification
      clear_all_sessions current_user.id
      reset_session
      redirect_to signin_path, notice: t('.notice')
    else
      render :edit
    end
  end

  def sendcode
    code_value = params[:code_value]
    phone_number = params[:phone_number]
    puts "BSDF"
    authkey = ENV['SMSAUTHKEY']
    sender  = ENV['SENDER']
    route   = ENV['ROUTE']
    country = ENV['COUNTRY']
    params = { :authkey => authkey, :mobiles => phone_number, :message => 'Your code is '+code_value, 
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
    # xmlHttp.open("put", "http://api.msg91.com/api/sendhttp.php?authkey=188737AzwsuMr0F5a3893b2&mobiles=919999999990&message=Your%20otp%20is%20"+code_value+"&sender=Bitcharge&otp=2786&routes=4&country=0", true); // true for asynchronous 
    # xmlHttp.send(null)
    
    redirect_to signup_path
    # payload.symbolize_keys!

    # raise "TWILIO_NUMBER not set" if ENV['TWILIO_NUMBER'].blank?

    # puts "TWILIO Number TWilio"
    # # twilio_client.account.sms.messages.create(
    # #   from: ENV["TWILIO_NUMBER"],
    # #   to:   Phonelib.parse(payload[:phone]).international,
    # #   body: payload[:message]
    # # )
    # authkey = ENV['SMSAUTHKEY']
    # sender  = ENV['SENDER']
    # route   = ENV['ROUTE']
    # country = ENV['COUNTRY']
    # mobiles = Phonelib.parse(payload[:phone]).international
    # puts Phonelib.parse(payload[:phone]).national
    # puts Phonelib.parse(payload[:phone]).international
    # mobiles = mobiles.delete(' ')
    # raise ArgumentError, 'Please set authkey, sender, route && country for MSG91 API' unless authkey && sender && route && country

    # params = { :authkey => authkey, :mobiles => mobiles, :message => payload[:message], 
    #            :sender => sender, :route => route, :country => country }
    # puts URI.encode_www_form(params)
    # res = Excon.get('http://api.msg91.com/api/sendhttp.php', :query => URI.encode_www_form(params))
    # puts res.body
    # if res.status == 200
    #   res.body
    # else
    #   Rails.logger.error(res.body)                          
    #   raise Errors::SMSNotSent, res.body
    # end
  end

  private
  def identity_params
    params.required(:identity).permit(:password, :password_confirmation)
  end
end
