Nanoc::Filter.define(:dart_sass) do |_content, _params|
  result = `sass -I. content/#{@item.identifier} --style compressed`
  raise "Dart-sass has failed" unless $?.success?
  result
end
