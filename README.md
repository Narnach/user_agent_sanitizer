User agent sanitizer
====================

Parse a HTTP user agent and attempt to return something that means something to a human.

Example:

    UserAgentSanitizer.sanitize_user_agent('Mozilla/5.0 (iPhone; CPU iPhone OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3')
    # => 'iPhone'
    
    UserAgentSanitizer.sanitize_user_agent('Mozilla/5.0 (Linux; U; Android 2.3.3; nl-nl; SAMSUNG GT-I9100/I9100BUKE5 Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1')
    # => 'Samsung GT-I9100'

New devices
-----------

Every time I encounter a new user agent that does not resolve to something useful, I add it as a test case and tweak the parser until all tested headers are correctly parsed. See [the spec](http://github.com/Narnach/user_agent_sanitizer/blob/master/spec/user_agent_sanitizer_spec.rb)

Contributing
------------

Create a Github issue and/or send a pull request.

Contributors
------------

* [Wes 'Narnach' Oldenbeuving](http://narnach.com/)