

get '/hello' do
	"hello, wrold118"
end

get '/api/ads' do
	options = params.symbolize_keys
	if options[:hqSource].to_s == 'youku'
		wp = options[:hqPrice].to_s
		price = decode_aes_price(wp)
		options = options.merge({:hqPrice => price})
	elsif options[:hqSource].to_s == 'baidu_bc'
	end
	
	if options[:hqEvent].to_s  == "1" #曝光
		ShowTracking << options
	elsif options[:hqEvent].to_s == '2' #点击
		ClickTracking << options
	elsif options[:hqEvent].to_s == '3' #竞价胜利
		BidderTracking << options
	elsif options[:hqEvent].to_s == '4' #下载
		DownloadTracking << options
	elsif options[:hqEvent].to_s == '5' #关注
		FollowTracking << options
	elsif options[:hqEvent].to_s == '6' #安装
		InstallationTracking << options
	elsif options[:hqEvent].to_s == '7' #激活
		ActiveTracking << options
	else
	end

	if options[:hqEvent].to_s == '3' #竞价胜利
	    rtb_key = "ad_#{params[:hqAdId]}_delivery_strategy"
	    keys = ["id", "budget_price", "cycle_delivery_price", "ad_current_cost", "ad_cost", "delivery_time_limit", "delivery_price", "delivery_start_time", "delivery_end_time", "ad_group_budget_price", "ad_group_current_cost", "account_buget_price", "account_current_cost"] 
		redis_info =  RtbRedis.expense_node.mapped_hmget(rtb_key, *keys)
		redis_info = redis_info.symbolize_keys
		actual_price = options[:hqPrice].to_i

		#账号花费
		redis_info[:account_current_cost] = redis_info[:account_current_cost].to_i + actual_price
		#广告组花费
		redis_info[:ad_group_current_cost] = redis_info[:ad_group_current_cost].to_i + actual_price
		#广告当前周期花费
		redis_info[:ad_current_cost] = redis_info[:ad_current_cost].to_i + actual_price
		#广告总花费
		redis_info[:ad_cost] = redis_info[:ad_cost].to_i + actual_price
		#更新广告花费
		RtbRedis.expense_node.mapped_hmset(rtb_key, redis_info)

		#实际花费＋固定出价 超出15分钟的预算，则从可投放数组种删除该条广告，并存入不可投递数组种，等待定时任务重新计算
		if redis_info[:ad_current_cost].to_i + redis_info[:delivery_price].to_i > redis_info[:cycle_delivery_price].to_i
			#删除可投地数组中的id
			budget_key = "budget_control"
			RtbRedis.expense_node.srem(budget_key, params[:hqAdId].to_i)
			#添加到不可投递数组中
			no_budget_key = "no_budget_control"
			RtbRedis.expense_node.sadd(no_budget_key, params[:hqAdId].to_i)
		end
	end
	des_url = options[:hqURL].to_s
	if des_url != ""	
	   redirect des_url, 302	
	end
end

private

def decode_aes_price(wp)
	price = Rtb::Aes::DecodePrice.decode_price(wp)
	price = price.nil? ? 0 : price.split('_')[0].to_i
	price 
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
