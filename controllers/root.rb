

get '/hello' do
	"hello, wrold"
end

get '/api/ads' do
	options = params.symbolize_keys
	keys = RedisKeys.new(options)
	if options[:hqEvent]  == "1" #曝光
		ShowTracking << options
		puts RtbRedis
		RtbRedis.expense_node.incr(keys.delivery_current_count_show)
	else #点击
		des_url = options[:hqRefer].to_s
		if des_url	
			begin
				ClickTracking << options
		  		RtbRedis.expense_node.incr(keys.delivery_current_count_click)
				redirect des_url	
			rescue Exception => e
				ErrorTracking << options.merge({:e => e})
			end
		end
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
