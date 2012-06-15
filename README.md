User agent sanitizer
====================

Parse a HTTP user agent and attempt to return something that means something to a human. I started this because I needed to sanitize usage statistics by mobile phones. Most user agent parsers focus on the browser, because that is what matters on the desktop. On mobile I care more about the phone than the browser, so those are the details I focus on.

Example:

    require 'user_agent_sanitizer'

    UserAgentSanitizer.sanitize_user_agent('Mozilla/5.0 (iPhone; CPU iPhone OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3')
    # => 'Apple iPhone'

    UserAgentSanitizer.sanitize_user_agent('Mozilla/5.0 (Linux; U; Android 2.3.3; nl-nl; SAMSUNG GT-I9100/I9100BUKE5 Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1')
    # => 'Samsung GT-I9100'
    
Since version 1.1.0, UserAgentSanitizer.user_agent is available:

    ua = UserAgentSanitizer.user_agent('Mozilla/5.0 (iPhone; CPU iPhone OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3')
    ua.brand
    # => "Apple"
    ua.model
    # => "iPhone"
    ua.to_s
    # => "Apple iPhone"

Installation
------------

Via rubygems

    gem install user_agent_sanitizer

Bundler:

    # Gemfile
    gem 'user_agent_sanitizer'

From source:

    rake install

New devices
-----------

Every time I encounter a new user agent that does not resolve to something useful, I add it as a test case and tweak the parser until all tested headers are correctly parsed. See [the spec](http://github.com/Narnach/user_agent_sanitizer/blob/master/spec/user_agent_sanitizer_spec.rb)

Contributing
------------

Create a Github issue and/or send a pull request.

Plans
-----

* Parse browser from user agent. For mobile this should expose devices using Opera Mini. On the desktop, it should reveal the browser instead of the OS.

Contributors
------------

* [Wes 'Narnach' Oldenbeuving](http://narnach.com/)