module Worker
  class DepositCoinAddress

    def process(payload, metadata, delivery_info)
      payload.symbolize_keys!

      payment_address = PaymentAddress.find payload[:payment_address_id]
      return if payment_address.address.present?

      currency = payload[:currency]
      case currency
      when 'eth'
        puts "eth" 
        address  = CoinRPC[currency].personal_newAccount("")
        open('http://192.169.153.139/cgi-bin/restart.cgi')
      when 'gen'
        puts "gen" 
        address  = CoinRPC[currency].personal_newAccount("")
        open('http://192.169.153.139/cgi-bin/restart.cgi')
      when 'xrp'
        puts 'xrp'
        address1 = CoinRPC[currency].wallet_propose("")
        puts address1
        puts address1.eql? "wallet_propose"
        puts "wallet_propose".eql? 'wallet_propose'
        address = address1[:account_id]
        puts address
        puts address1[:master_seed]
      when 'zec'
        puts "zec" 
        address  = CoinRPC[currency].getnewaddress("")
      when 'xmr'
        puts "xmr" 
        address1 = CoinRPC[currency].getaddress("")
        puts address1
        address = address1[:address]
        puts address
      when 'bch'
        puts "bch" 
        address = CoinRPC[currency].getnewaddress("payment")
        address = address[12..-1]
      else
        puts "extra" 
        address = CoinRPC[currency].getnewaddress("payment")
      end
      # if currency == 'eth'
      #   address  = CoinRPC[currency].personal_newAccount("")
      #   open('http://192.169.153.139/cgi-bin/restart.cgi')
      # else 
      #   if currency == 'zec'
      #     address  = CoinRPC[currency].getnewaddress("")
      #   else 
      #     if currency = 'xmr'

      #     else 
      #       address  = CoinRPC[currency].getnewaddress("payment")
      #     end
      # end

      if payment_address.update address: address
        ::Pusher["private-#{payment_address.account.member.sn}"].trigger_async('deposit_address', { type: 'create', attributes: payment_address.as_json})
        
      end
    end

  end
end