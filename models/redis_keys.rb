class RedisKeys
	def initialize(options)
		@user_id = options[:hqClientId]
		@group_id = options[:hqGroupId]
		@ad_id = options[:hqGroupId]
		@creative_id = options[:hqCreativeId]
		@refer_url = options[:hqRefer]
		@ad_time = options[:hqTime]
		@event = options[:hqEvent]
		@price = options[:hqGroupId]
		@source = options[:hqSource]
		@uid = options[:hquid]
	end

	def id
		"delivery_ad_#{@ad_id}_#{@user_id}"
	end

	def budget_price
		"delivery_ad_#{@ad_id}_#{@user_id}_budget_price"
	end

	def delivery_current_count_show
		"delivery_ad_#{@ad_id}_#{@user_id}_delivery_current_count_show"
	end

	def delivery_current_count_click
		"delivery_ad_#{@ad_id}_#{@user_id}_delivery_current_count_click"
	end

	def delivery_total_count
		"delivery_ad_#{@ad_id}_#{@user_id}_delivery_total_count"
	end

	def delivery_time_limit
		"delivery_ad_#{@ad_id}_#{@user_id}_delivery_time_limit"
	end

	def delivery_price
		"delivery_ad_#{@ad_id}_#{@user_id}_delivery_price"
	end

	def delivery_start_time
		"delivery_ad_#{@ad_id}_#{@user_id}_delivery_start_time"
	end
end