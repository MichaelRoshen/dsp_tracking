

get '/hello' do
	"hello, wrold118"
end

get '/api/ads' do
	options = params.symbolize_keys
	if options[:hqEvent].to_s  == "1" #曝光
		ShowTracking << options
	elsif options[:hqEvent].to_s == '2' #点击
		ClickTracking << options
	else
	end

	des_url = options[:hqURL].to_s
	if des_url != ""	
	   redirect des_url, 302	
	end
end

private

class Hash
	def symbolize_keys
		self.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
	end
end


def decode_tanx_price(wp)
	Rtb::Tanx::DecodePrice.decode_price(wp)
end

def decode_gadx_price(wp)
	Rtb::Gadx::DecodePrice.decode_price(wp)
end

def decode_allyes_price(wp)
	Rtb::Allyes::DecodePrice.decode_price(wp)
end

def decode_mega_price(wp)
	Rtb::Mega::DecodePrice.decode_price(wp)
end

def decode_gdt_price(wp)
Rtb::Gdt::DecodePrice.decode_price(wp)
end
