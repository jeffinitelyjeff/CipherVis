guard 'coffeescript', :output => 'public' do
  watch /^src\/.+\.coffee$/
end

guard 'shell' do
  watch /^src\/.+\.coffee$/ do |m|
    `docco #{m[0]}`
    puts "Generated documentation for #{m[0]}"
  end
end

guard 'coffeescript', :output => 'spec' do
  watch /^spec\/.+\.coffee$/
end

guard 'haml', :input => 'src', :output => 'public' do
  watch /.+\.haml$/
end

guard 'sass', :output => 'public' do
  watch /^src\/.+\.sass$/
end

# guard 'jasmine' do
#   watch /^spec\/.+\.js$/
# end
