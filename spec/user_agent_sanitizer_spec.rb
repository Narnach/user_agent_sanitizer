# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'user_agent_sanitizer'

describe UserAgentSanitizer do
  DEVICES = {
      ### Mobile devices

      # Apple
      'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A405 Safari/7534.48.3' => ['Apple', 'iPhone'],
      'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_5 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8L1 Safari/6533.18.5' => ['Apple', 'iPhone'],
      'Mozilla/5.0 (iPhone; U; CPU like Mac OS X; nl-nl) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/4A102 Safari/419.3' => ['Apple', 'iPhone'],

      # Blackberry
      'BlackBerry8520/4.6.1.296 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/150' => ['BlackBerry', '8520'],
      'BlackBerry8900/4.6.1.199 Profile/MIDP-2.0 Configuration/CLDC-1.1 VendorID/302' => ['BlackBerry', '8900'],
      'Mozilla/5.0 (BlackBerry; U; BlackBerry 9800; nl) AppleWebKit/534.1+ (KHTML, like Gecko) Version/6.0.0.246 Mobile Safari/534.1+' => ['BlackBerry', '9800'],

      # HTC
      'HTC_Touch2_T3333 Opera/9.50 (Windows NT 5.1; U; nl)' => ['HTC', 'Touch2'],
      'Mozilla/5.0 (Linux; U; Android 1.5; en-gb; HTC Magic Build/CRB17) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1' => ['HTC', 'Magic'],
      'Mozilla/5.0 (Linux; U; Android 2.1-update1; nl-nl; Desire_A8181 Build/ERE27) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17' => ['HTC', 'Desire'],
      'Mozilla/5.0 (Linux; U; Android 2.3.5; nl-nl; HTC_DesireHD_A9191 Build/GRJ90) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['HTC', 'Desire HD'],
      'Mozilla/5.0 (Linux; U; Android 2.1; nl-nl; HTC Legend Build/ERD79) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17' => ['HTC', 'Legend'],
      'Mozilla/5.0 (Linux; U; Android 2.2; nl-nl; HTC_DesireZ_A7272 Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['HTC', 'Desire Z'],
      'Mozilla/5.0 (Linux; U; Android 2.3.3; nl-nl; HTC/DesireS/1.32.161.2 Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['HTC', 'Desire S'],
      'Mozilla/5.0 (Linux; U; Android 2.3.6; en-us; Nexus One Build/GRK39F) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['HTC', 'Nexus One'],
      'Mozilla/5.0 (Linux; U; Android 4.0.3; nl-nl; SensationXE_Beats_Z715e Build/IML74K) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30' => ['HTC', 'Sensation XE Beats'],
      'Mozilla/5.0 (Linux; U; Android 4.0.3; nl-nl; HTC_One_X Build/IML74K) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30' => ['HTC', 'One X'],
      'Mozilla/5.0 (Linux; U; Android 2.2.1; nl-nl; HTC_Wildfire_A3333 Build/FRG83D) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['HTC', 'Wildfire'],
      'Mozilla/5.0 (Linux; U; Android 2.3.5; nl-nl; HTC_WildfireS_A510e Build/GRJ90) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['HTC', 'Wildfire S'],
      'Mozilla/5.0 (Linux; U; Android 2.3.5; nl-nl; HTC Wildfire S A510e Build/GRJ90) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['HTC', 'Wildfire S'],

      # LG
      'LG-GD510/V100 Teleca/WAP2.0 Profile/MIDP-2.1 Configuration/CLDC-1.1' => ['LG', 'GD510'],
      'LG/KU990/v10a Browser/Obigo-Q05A/3.6 MMS/LG-MMS-V1.0/1.2 Java/ASVM/1.0 Profile/MIDP-2.0 Configuration/CLDC-1.1' => ['LG', 'KU990'],

      # Nokia
      'Mozilla/5.0 (SymbianOS/9.2; U; Series60/3.1 NokiaE90-1/07.24.0.3; Profile/MIDP-2.0 Configuration/CLDC-1.1 ) AppleWebKit/413 (KHTML, like Gecko) Safari/413' => ['Nokia', 'E90'],
      'Mozilla/5.0 (SymbianOS/9.3; U; Series60/3.2 NokiaE75-1/110.48.125 Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/413 (KHTML, like Gecko) Safari/413' => ['Nokia', 'E75'],
      '(compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0; NOKIA; Lumia 800)' => ['Nokia', 'Lumia 800'],

      # Samsung
      'Mozilla/5.0 (Linux; U; Android 1.5; nl-nl; GT-I5700 Build/CUPCAKE) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1' => ['Samsung', 'GT-I5700'],
      'Mozilla/5.0 (Linux; U; Android 2.3.3; nl-nl; GT-I9100 Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['Samsung', 'GT-I9100'],
      'Mozilla/5.0 (Linux; U; Android 2.3.3; nl-nl; SAMSUNG GT-I9100/I9100BUKE5 Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['Samsung', 'GT-I9100'],
      'Mozilla/5.0 (SAMSUNG; SAMSUNG-GT-S8500/S8500XXJEC; U; Bada/1.0; nl-nl) AppleWebKit/533.1 (KHTML, like Gecko) Dolfin/2.0 Mobile WVGA SMM-MMS/1.2.0 OPN-B' => ['Samsung', 'GT-S8500'],
      'Mozilla/5.0 (SymbianOS/9.4; U; Series60/5.0 Samsung/I8910; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 Safari/525' => ['Samsung', 'I8910'],
      'SAMSUNG-GT-C3510/C3510XXIL4 NetFront/3.5 Profile/MIDP-2.0 Configuration/CLDC-1.1' => ['Samsung', 'GT-C3510'],
      'SAMSUNG-SGH-L600/L600ASGI3 Profile/MIDP-2.0 Configuration/CLDC-1.1 UP.Browser/6.2.3.3.c.1.101 (GUI) MMP/2.0' => ['Samsung', 'SGH L600'],
      'Mozilla/5.0 (Linux; U; Android 4.1.1; nl-nl; Galaxy Nexus Build/JRO03C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30' => ['Samsung', 'Galaxy Nexus'],
      '(Linux; Android 4.1.1; Galaxy Nexus Build/JRO03C) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.166 Mobile Safari/535.19' => ['Samsung', 'Galaxy Nexus'],

      # SonyEricsson
      'Mozilla/5.0 (Linux; U; Android 1.6; nl-nl; SonyEricssonX10i Build/R1FA016) AppleWebKit/528.5+ (KHTML, like Gecko) Version/3.1.2 Mobile Safari/525.20.1' => ['SonyEricsson', 'X10i'],
      'SonyEricssonW995/R1FA Browser/NetFront/3.4 Profile/MIDP-2.1 Configuration/CLDC-1.1 JavaPlatform/JP-8.4.3' => ['SonyEricsson', 'W995'],

      # Other
      'Mozilla/5.0 (Linux; U; Android 2.2.1; es-es; Vodafone 858 Build/Vodafone858C02B617) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['Vodafone', '858'],
      'Mozilla/5.0 (Linux; U; Android 2.2; es-es; Light Pro Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['Light', 'Pro'],
      'Mozilla/5.0 (Linux; U; Android 2.3.5; es-es; ZTE Skate Build/V1.0.0B03) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['ZTE', 'Skate'],
      'SAGEM-my411C/1.0/ MIDP-2.0 Configuration/CLDC-1.1 Browser/UP.Browser/7.2.6.c.1.386 (GUI)' => ['SAGEM', 'my411C'],
      'SEC-SGHM620/1.0 Openwave/6.2.3 Profile/MIDP-2.0 Configuration/CLDC-1.1 UP.Browser/6.2.3.3.c.1.101 (GUI) MMP/2.0' => ['SEC', 'SGH M620'],
      'Mozilla/5.0 (Linux; U; Android 2.2.2; nl-nl; ALCATEL_one_touch_990 Build/FRG83G) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['Alcatel', 'One Touch 990'],
      'Mozilla/5.0 (Linux; U; Android 2.3.6; nl-nl; ALCATEL ONE TOUCH 991 Build/GRJ90) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['Alcatel', 'One Touch 991'],
      'Mozilla/5.0 (Linux; U; Android 2.3.6; nl-nl; ALCATEL_one_touch_995 Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1' => ['Alcatel', 'One Touch 995'],

      # Mobile browsers
      '(Android 4.0.3; Linux; Opera Mobi/ADR-1205181138; U; nl) Presto/2.10.254 Version/12.00' => ['Opera', 'Mobi'],
      'Opera/9.80 (BlackBerry; Opera Mini/5.1.22303/24.871; U; pt) Presto/2.5.25 Version/10.54' => ['Opera', 'Mini'],

      # Tables and other handhelds
      '(iPad; CPU OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3' => ['Apple', 'iPad'],
      '(PSP (PlayStation Portable); 2.00)' => ['Sony', 'PSP'],
      'Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8F190 Safari/6533.18.5' => ['Apple', 'iPod'],

      # Desktop
      'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; GTB0.0; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.5.30729; .NET CLR 3.0.30618)' => ['Microsoft', 'Windows NT 6.0'],
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20100101 Firefox/11.0' => ['Apple', 'Mac OS X 10.7'],
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5' => ['Apple', 'Mac OS X 10.7.4'],
      'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; nl-nl) AppleWebKit/525.18 (KHTML, like Gecko) Version/3.1.2 Safari/525.20.1' => ['Apple', 'Mac OS X 10.5.5'],
      'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; en-us) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10' => ['Apple', 'Mac OS X 10.6.2'],
      '(Windows; U; Windows NT 6.1; en-US; rv:1.9.2.10) Gecko/20100914 Firefox/3.6.10' => ['Microsoft', 'Windows NT 6.1'],
      'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)' => ['Microsoft', 'Windows NT 6.1'],
  }
  describe "sanitize_user_agent" do
    DEVICES.each do |user_agent, brand_model|
      device_name = brand_model.join(" ").strip
      it "should return #{device_name.inspect} for #{user_agent.inspect}" do
        UserAgentSanitizer.sanitize_user_agent(user_agent).should == device_name
      end
    end
  end

  describe "user_agent" do
    DEVICES.each do |user_agent, brand_model|
      brand, model = *brand_model
      it "should return brand #{brand.inspect} and model #{model.inspect} for #{user_agent.inspect}" do
        ua=UserAgentSanitizer.user_agent(user_agent)
        ua.to_s.should == brand_model.join(" ").strip
        ua.brand.should == brand
        ua.model.should == model
        ua.user_agent.should == user_agent
      end
    end
  end
end
