source "https://rubygems.org"

# Use github-pages gem for GitHub Pages compatibility
gem "github-pages", group: :jekyll_plugins

# Pin connection_pool to 2.x for Ruby 3.1.7 compatibility (GitHub Actions)
gem "connection_pool", "~> 2.4"

# Pin minitest to 5.x for Ruby 3.1.7 compatibility (GitHub Actions)
gem "minitest", "~> 5.0"

# Pin activesupport to 7.x for Ruby 3.1.7 compatibility (GitHub Actions)
gem "activesupport", "~> 7.0"

# Pin nokogiri to 1.16.x for Ruby 3.1.7 compatibility (GitHub Actions)
gem "nokogiri", "~> 1.16.0"

# Pin public_suffix to 5.x for Ruby 3.1.7 compatibility (GitHub Actions)
gem "public_suffix", "~> 5.0"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
  gem "jekyll-paginate"
end

gem "webrick", "~> 1.8"

# Windows and JRuby does not include zoneinfo files
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.1", :platforms => [:mingw, :x64_mingw, :mswin]
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
