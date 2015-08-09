 namespace :dsp do
   desc 'greet :test for rake task'
   task :greet do
      puts "Hello!"
   end

   desc 'reset :reset no_budget_control'
   task :reset do
   	  require 'time'
   	  no_budget_key = "no_budget_control"
      RtbRedis.expense_node.smembers(no_budget_key).uniq.map{|item|item.to_i}.each do |ad|
      	puts ad
      	rtb_key = "ad_#{ad.to_i}_delivery_strategy"
	    keys = ["id", "budget_price", "cycle_delivery_price", "ad_current_cost", "ad_cost", "delivery_time_limit", "delivery_price", "delivery_start_time", "delivery_end_time", "ad_group_budget_price", "ad_group_cost", "account_buget_price", "account_cost"] 
		redis_info =  RtbRedis.expense_node.mapped_hmget(rtb_key, *keys)
		redis_info = redis_info.symbolize_keys
		puts redis_info
      	if redis_info[:budget_price].to_f - redis_info[:ad_cost].to_f > redis_info[:cycle_delivery_price].to_f &&
      		redis_info[:ad_group_budget_price].to_f - redis_info[:ad_group_cost].to_f > redis_info[:cycle_delivery_price].to_f &&
      		redis_info[:account_buget_price].to_f - redis_info[:account_cost].to_f > redis_info[:cycle_delivery_price].to_f &&
      		Time.at(redis_info[:delivery_start_time].to_i) < Time.now && 
      		Time.now < Time.at(redis_info[:delivery_end_time].to_i) 
      		puts "delivery agin...."
      		redis_info[:ad_current_cost] = 0.0
      		budget_key = "budget_control"
			RtbRedis.expense_node.mapped_hmset(rtb_key, redis_info)
			RtbRedis.expense_node.sadd(budget_key, redis_info[:id])
			RtbRedis.expense_node.srem(no_budget_key, redis_info[:id])
      	end
      end
   end   

   desc 'redis seed'
   task :redis_seed do 
	hash = {"id"=>"15", "budget_price"=>"120000", "cycle_delivery_price"=>"312", "ad_current_cost"=>"0.0", "ad_cost"=>"0.0", "delivery_time_limit"=>"96", "delivery_price"=>"600", "delivery_start_time"=>"1438790400", "delivery_end_time"=>"1439136000", "ad_group_budget_price"=>"120000", "ad_group_cost"=>"0.0", "account_buget_price"=>"200000", "account_cost"=>"0.0"}
	rtb_key = "ad_15_delivery_strategy"
	puts rtb_key
	RtbRedis.expense_node.mapped_hmset(rtb_key, hash)
	RtbRedis.expense_node.sadd('budget_control',[15])
   end
end

