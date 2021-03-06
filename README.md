# Ninescrap

**9GAG** unofficial API in *Ruby* to scrap data from the website posts.

## Description

It can be used to retrieve data in order to feed a database.
A *Post*, once loaded, can be serialized via _to\_json_ method.

For now, it only gather simple post information, and the first 20 comments.

## Requirements

* Download the **chromedriver** to make **Watir** work. [chromedriver links](https://sites.google.com/a/chromium.org/chromedriver/downloads).
* Once downloaded, add its path to your *PATH*
* You should be able to execute the following command in your terminal :

```bash
$ chromedriver
```

* By default, **Watir** opens a browser to load dynamic content. To avoir that, we use *headless*, which does the same without opening anything. It requires **xvfb**.
```bash
$ sudo apt-get install xvfb
```

## Installation

In the downloaded repo, build it with:

```bash
$ gem build ninescrap.gemspec
```

Install it with :

```bash
$ gem install ninescrap
```

And get all the dependencies with _bundler_:
```
$ bundler install
```

### Check installation

To check if it installed properly

```bash
   $ irb
   > require 'ninescrap'
    => true
```


## Usage

```ruby
#! /usr/bin/env ruby
require 'ninescrap'

# Standard usage
post = NineScrap.fromUrl "http://9gag.com/gag/aeYB7rO"
puts JSON.generate post

# Multiple urls to fetch
urls = Array.new
urls.push "http://9gag.com/gag/aeYB7rO"
posts = NineScrap.fromArray urls

posts.each do |p|
  puts JSON.generate p
end

```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
