
require 'sinatra'

%w{initializers lib  controllers models }.each do |dir|
  Dir.glob(File.expand_path("../#{dir}", __FILE__) + '/**/*.rb').each do |file|
    require file
  end
end
 

