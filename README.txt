= bitly

== DESCRIPTION:

A Ruby API for http://bit.ly (and now http://j.mp)

http://code.google.com/p/bitly-api/wiki/ApiDocumentation

== INSTALLATION:

gem install bitly

== USAGE:

Create a Bitly client using your username and api key as follows:

bitly = Bitly.new(username, api_key)

You can then use that client to shorten or expand urls or return more information or statistics as so:

bitly.shorten('http://www.google.com')
bitly.shorten('http://www.google.com', :history => 1) # adds the url to the api user's history
bitly.expand('wQaT')
bitly.info('http://bit.ly/wQaT')
bitly.stats('http://bit.ly/wQaT')

Each can be used in all the methods described in the API docs, the shorten function, for example, takes a url or an array of urls.

All four functions return a Bitly::Url object (or an array of Bitly::Url objects if you supplied an array as the input). You can then get all the information required from that object.

u = bitly.shorten('http://www.google.com') #=> Bitly::Url

u.long_url #=> "http://www.google.com"
u.short_url #=> "http://bit.ly/Ywd1"
u.bitly_url #=> "http://bit.ly/Ywd1"
u.jmp_url #=> "http://j.mp/Ywd1"
u.user_hash #=> "Ywd1"
u.hash #=> "2V6CFi"
u.info #=> a ruby hash of the JSON returned from the API
u.stats #=> a ruby hash of the JSON returned from the API

bitly.shorten('http://www.google.com', 'keyword')

== LICENSE:

(The MIT License)

Copyright (c) 2009 Phil Nash

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
