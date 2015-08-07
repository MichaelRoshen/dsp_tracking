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
      		Time.at(redis_info[:delivery_start_time].to_i) < Time.now && Time.now < Time.at(redis_info[:delivery_end_time].to_i) 
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
   	redis_info =
	 [{"id"=>1, "budget_price"=>2880, "cycle_delivery_price"=>10, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>72, 
	 	"delivery_price"=>4, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-10 00:00:00", "ad_group_budget_price"=>4000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>5000, "account_current_cost"=>0.0
	 },{"id"=>2, "budget_price"=>2880, "cycle_delivery_price"=>20, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>36, 
	 	"delivery_price"=>5, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-20 00:00:00", "ad_group_budget_price"=>45000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>55000, "account_current_cost"=>0.0
	 },{"id"=>3, "budget_price"=>7200, "cycle_delivery_price"=>15, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>120, 
	 	"delivery_price"=>4, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-10 00:00:00", "ad_group_budget_price"=>4000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>55000, "account_current_cost"=>0.0
	 },{"id"=>4, "budget_price"=>28800, "cycle_delivery_price"=>30, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>240, 
	 	"delivery_price"=>8, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-10 00:00:00", "ad_group_budget_price"=>45000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>55000, "account_current_cost"=>0.0
	 },{"id"=>5, "budget_price"=>2400, "cycle_delivery_price"=>10, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>60, 
	 	"delivery_price"=>4, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-10 00:00:00", "ad_group_budget_price"=>45000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>55000, "account_current_cost"=>0.0
	 },{"id"=>6, "budget_price"=>69120, "cycle_delivery_price"=>24, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>720, 
	 	"delivery_price"=>4, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-10 00:00:00", "ad_group_budget_price"=>45000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>55000, "account_current_cost"=>0.0
	 },{"id"=>7, "budget_price"=>2880, "cycle_delivery_price"=>30, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>100, 
	 	"delivery_price"=>10, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-10 00:00:00", "ad_group_budget_price"=>45000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>55000, "account_current_cost"=>0.0
	 },{"id"=>8, "budget_price"=>86400, "cycle_delivery_price"=>60, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>360, 
	 	"delivery_price"=>24, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-10 00:00:00", "ad_group_budget_price"=>45000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>55000, "account_current_cost"=>0.0
	 },{"id"=>9, "budget_price"=>24000, "cycle_delivery_price"=>30, 
	 	"ad_current_cost"=>0.0, "ad_cost"=>0.0, "delivery_time_limit"=>200, 
	 	"delivery_price"=>8, "delivery_start_time"=>"2015-07-01 00:00:00", 
	 	"delivery_end_time"=>"2015-07-10 00:00:00", "ad_group_budget_price"=>45000, 
	 	"ad_group_current_cost"=>0.0, "account_buget_price"=>55000, "account_current_cost"=>0.0
	 }] 
	redis_info.each do |info|
		rtb_key = "ad_#{info['id']}_delivery_strategy"
		puts rtb_key
		RtbRedis.expense_node.mapped_hmset(rtb_key, info)
	end
	RtbRedis.expense_node.sadd('budget_control',[1,2,3,4,5,6,7,8,9])
   end
end

