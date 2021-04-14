{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  adsf = {
    dependencies = ["rack"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w56jzrx2z1dd74qj3x641b3ar6i4c170xqfq51gja3fq35flkas";
      type = "gem";
    };
    version = "1.4.5";
  };
  adsf-live = {
    dependencies = ["adsf" "em-websocket" "eventmachine" "listen" "rack-livereload"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dvbdy113xlcnafjzhgjiqmssycfmlnlawr31m66kyfvlgx952g9";
      type = "gem";
    };
    version = "1.4.5";
  };
  autoprefixer-rails = {
    dependencies = ["execjs"];
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05z02ylv8rbcc3k6zlngizixc9csy779cqmlaa8hn7kylxizk3gy";
      type = "gem";
    };
    version = "10.2.4.0";
  };
  builder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  coderay = {
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  colored = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0x5jmsyi0z69bm6sij1k89z7h0laag3cb4mdn7zkl9qmxb90lx";
      type = "gem";
    };
    version = "1.2";
  };
  concurrent-ruby = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mr23wq0szj52xnj0zcn1k0c7j4v79wlwbijkpfcscqww3l6jlg3";
      type = "gem";
    };
    version = "1.1.8";
  };
  cri = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bhsgnjav94mz5vf3305gxz1g34gm9kxvnrn1dkz530r8bpj0hr5";
      type = "gem";
    };
    version = "2.15.11";
  };
  ddmemoize = {
    dependencies = ["ddmetrics" "ref"];
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15ylhhfhd35zlr0wzcc069h0sishrfn27m0q54lf7ih092mccb6l";
      type = "gem";
    };
    version = "1.0.0";
  };
  ddmetrics = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0in0hk546q3js6qghbifjqvab6clyx5fjrwd3lcb0mk1ihmadyn2";
      type = "gem";
    };
    version = "1.0.1";
  };
  ddplugin = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14hbvr6qjcn1i6pin8rq9kr02f98imskhrl8k53117mlfxxhl9sv";
      type = "gem";
    };
    version = "1.0.3";
  };
  diff-lcs = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m925b8xc6kbpnif9dldna24q1szg4mk0fvszrki837pfn46afmz";
      type = "gem";
    };
    version = "1.4.4";
  };
  em-websocket = {
    dependencies = ["eventmachine" "http_parser.rb"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mg1mx735a0k1l8y14ps2mxdwhi5r01ikydf34b0sp60v66nvbkb";
      type = "gem";
    };
    version = "0.5.2";
  };
  eventmachine = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  execjs = {
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
  };
  ffi = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nq1fb3vbfylccwba64zblxy96qznxbys5900wd7gm9bpplmf432";
      type = "gem";
    };
    version = "1.15.0";
  };
  formatador = {
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gc26phrwlmlqrmz4bagq1wd5b7g64avpx0ghxr9xdxcvmlii0l0";
      type = "gem";
    };
    version = "0.2.5";
  };
  guard = {
    dependencies = ["formatador" "listen" "lumberjack" "nenv" "notiffany" "pry" "shellany" "thor"];
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fwgvkmrg97xfswwgfrfcl1nc937yxwazfvpmf8vxj7cvnx7mfki";
      type = "gem";
    };
    version = "2.16.2";
  };
  guard-compat = {
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj6sr1k8w59mmi27rsii0v8xyy2rnsi09nqvwpgj1q10yq1mlis";
      type = "gem";
    };
    version = "1.2.1";
  };
  guard-nanoc = {
    dependencies = ["guard" "guard-compat" "nanoc-cli" "nanoc-core"];
    groups = ["nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1whi9i9b4ffqs7awsjjrlpaq2gi5846yks1fy6s30pg50chn73ah";
      type = "gem";
    };
    version = "2.1.9";
  };
  hamster = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1lsh96vnyc1pnzyd30f9prcsclmvmkdb3nm5aahnyizyiy6lar";
      type = "gem";
    };
    version = "3.0.0";
  };
  highline = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
  };
  htmlcompressor = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17hzzg7alnmalb1xgv1bgw3aj5wczsijhq6c945kymkbsj7cyc26";
      type = "gem";
    };
    version = "0.4.0";
  };
  "http_parser.rb" = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
  };
  icalendar = {
    dependencies = ["ice_cube"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wv5wq6pzq6434bnxfanvijswj2rnfvjmgisj1qg399mc42g46ls";
      type = "gem";
    };
    version = "2.7.1";
  };
  ice_cube = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rzfydzgy6jppqvzzr76skfk07nmlszpcjzzn4wlzpsgmagmf0wq";
      type = "gem";
    };
    version = "0.16.3";
  };
  json = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lrirj0gw420kw71bjjlqkqhqbrplla61gbv1jzgsz6bv90qr3ci";
      type = "gem";
    };
    version = "2.5.1";
  };
  json_schema = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nzcnb9j7bbj3nc6izwlsxky8j4xly345qzfg5v5n6550kqfmqfn";
      type = "gem";
    };
    version = "0.21.0";
  };
  katex = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1815kc0hicy1am2plyim06zqb5dwj5hy8hgfdd05z3lnvv1l5ckj";
      type = "gem";
    };
    version = "0.6.1";
  };
  kramdown = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jdbcjv4v7sj888bv3vc6d1dg4ackkh7ywlmn9ln2g9alk7kisar";
      type = "gem";
    };
    version = "2.3.1";
  };
  kramdown-math-katex = {
    dependencies = ["katex" "kramdown"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p2cn05pk26lixbag0hvvyxz9b4hizl1hz8hwawlkv6mzscv46bi";
      type = "gem";
    };
    version = "1.0.1";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h2v34xhi30w0d9gfzds2w6v89grq2gkpgvmdj9m8x1ld1845xnj";
      type = "gem";
    };
    version = "3.5.1";
  };
  lumberjack = {
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06pybb23hypc9gvs2p839ildhn26q68drb6431ng3s39i3fkkba8";
      type = "gem";
    };
    version = "1.2.8";
  };
  method_source = {
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  mini_portile2 = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hdbpmamx8js53yk3h8cqy12kgv6ca06k0c9n3pxh6b6cjfs19x7";
      type = "gem";
    };
    version = "2.5.0";
  };
  nanoc = {
    dependencies = ["addressable" "colored" "nanoc-checking" "nanoc-cli" "nanoc-core" "nanoc-deploying" "parallel" "tty-command" "tty-which"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dylmcbblxj0sbwjiym961amxvj0r8yks47kdw9ssfbx9wg73chw";
      type = "gem";
    };
    version = "4.12.0";
  };
  nanoc-checking = {
    dependencies = ["nanoc-cli" "nanoc-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bdmvq90s2pbxlala8ami6w2zb1zlqjhm69wn7wwxzh3kp2r9js";
      type = "gem";
    };
    version = "1.0.1";
  };
  nanoc-cli = {
    dependencies = ["cri" "diff-lcs" "nanoc-core" "zeitwerk"];
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mz93msccaa4g5dkjab5j77g7b353zavxia7wvrwmgccznmli9p1";
      type = "gem";
    };
    version = "4.12.0";
  };
  nanoc-core = {
    dependencies = ["concurrent-ruby" "ddmemoize" "ddmetrics" "ddplugin" "hamster" "json_schema" "slow_enumerator_tools" "tomlrb" "tty-platform" "zeitwerk"];
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yibscgw82dafqp4giprmvbqz3zadka8ywvgpd6lgm1kf4c3j1qm";
      type = "gem";
    };
    version = "4.12.0";
  };
  nanoc-deploying = {
    dependencies = ["nanoc-checking" "nanoc-cli" "nanoc-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02l19qjsaj9rn1iw8fkpc1dmccgniggd4r7xvpsvvdl4nlrl56sq";
      type = "gem";
    };
    version = "1.0.1";
  };
  nanoc-live = {
    dependencies = ["adsf-live" "listen" "nanoc-cli" "nanoc-core"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mnyibl977narr9k6n9wz3cpry03vkc5bwffnxbv34qfp873dqx7";
      type = "gem";
    };
    version = "1.0.0";
  };
  nenv = {
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r97jzknll9bhd8yyg2bngnnkj8rjhal667n7d32h8h7ny7nvpnr";
      type = "gem";
    };
    version = "0.3.0";
  };
  nio4r = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00fwz0qq7agd2xkdz02i8li236qvwhma3p0jdn5bdvc21b7ydzd5";
      type = "gem";
    };
    version = "2.5.7";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b51df8fwadak075cvi17w0nch6qz1r66564qp29qwfj67j9qp0p";
      type = "gem";
    };
    version = "1.11.2";
  };
  notiffany = {
    dependencies = ["nenv" "shellany"];
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f47h3bmg1apr4x51szqfv3rh2vq58z3grh4w02cp3bzbdh6jxnk";
      type = "gem";
    };
    version = "0.1.3";
  };
  pandoc-ruby = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y7i5f2i67n1j91vnc2gwscjc1z7k1axfl2hbsk4y30y2k1qam94";
      type = "gem";
    };
    version = "2.1.4";
  };
  parallel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0055br0mibnqz0j8wvy20zry548dhkakws681bhj3ycb972awkzd";
      type = "gem";
    };
    version = "1.20.1";
  };
  pastel = {
    dependencies = ["tty-color"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xash2gj08dfjvq4hy6l1z22s5v30fhizwgs10d6nviggpxsj7a8";
      type = "gem";
    };
    version = "0.8.0";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1shq3vfdg7c9l1wppl8slridl95wmwvnngqhga6j2571nnv50piv";
      type = "gem";
    };
    version = "0.14.0";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wiprd0v4mjqv5p1vqaidr9ci2xm08lcxdz1k50mb1b6nrw6r74k";
      type = "gem";
    };
    version = "5.2.2";
  };
  racc = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "178k7r0xn689spviqzhvazzvxfq6fyjldxb3ywjbgipbfi4s8j1g";
      type = "gem";
    };
    version = "1.5.2";
  };
  rack = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
  };
  rack-livereload = {
    dependencies = ["rack"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1slzlmvlapgp2pc7389i0zndq3nka0s6sh445vf21cxpz7vz3p5i";
      type = "gem";
    };
    version = "0.3.17";
  };
  rainpress = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhd2l9963k0fv9q5rck2zbp3c1q8c0xpw8nvgjizq3wgmy282q4";
      type = "gem";
    };
    version = "1.0.1";
  };
  rb-fsevent = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k9bsj7ni0g2fd7scyyy1sk9dy2pg9akniahab0iznvjmhn54h87";
      type = "gem";
    };
    version = "0.10.4";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      type = "gem";
    };
    version = "0.10.1";
  };
  ref = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04p4pq4sikly7pvn30dc7v5x2m7fqbfwijci4z1y6a1ilwxzrjii";
      type = "gem";
    };
    version = "2.0.0";
  };
  rexml = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkvkcw9fhpaizrhca0pdgjcrbns48rlz4g6lavl5gjjq3rk2sq3";
      type = "gem";
    };
    version = "3.2.4";
  };
  rubypants = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kv2way45d2dz3h5b7wxyw36clvlwrz7ydf6699d0za5vm56gsrh";
      type = "gem";
    };
    version = "0.7.1";
  };
  sassc = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gpqv48xhl8mb8qqhcifcp0pixn206a7imc07g48armklfqa4q2c";
      type = "gem";
    };
    version = "2.4.0";
  };
  shellany = {
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ryyzrj1kxmnpdzhlv4ys3dnl2r5r3d2rs2jwzbnd1v96a8pl4hf";
      type = "gem";
    };
    version = "0.0.1";
  };
  slow_enumerator_tools = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0phfj4jxymxf344cgksqahsgy83wfrwrlr913mrsq2c33j7mj6p6";
      type = "gem";
    };
    version = "1.1.0";
  };
  terminal-notifier = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1slc0y8pjpw30hy21v8ypafi8r7z9jlj4bjbgz03b65b28i2n3bs";
      type = "gem";
    };
    version = "2.0.0";
  };
  terminal-notifier-guard = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hcpqljmlgs4z54n48dwks8h49q4h7k4jvcf8ah1p4zrbsqirck6";
      type = "gem";
    };
    version = "1.7.0";
  };
  thor = {
    groups = ["default" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18yhlvmfya23cs3pvhr1qy38y41b6mhr5q9vwv5lrgk16wmf3jna";
      type = "gem";
    };
    version = "1.1.0";
  };
  tomlrb = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00x5y9h4fbvrv4xrjk4cqlkm4vq8gv73ax4alj3ac2x77zsnnrk8";
      type = "gem";
    };
    version = "1.3.0";
  };
  tty-color = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aik4kmhwwrmkysha7qibi2nyzb4c8kp42bd5vxnf8sf7b53g73g";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-command = {
    dependencies = ["pastel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14hi8xiahfrrnydw6g3i30lxvvz90wp4xsrlhx8mabckrcglfv0c";
      type = "gem";
    };
    version = "0.10.1";
  };
  tty-platform = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02h58a8yg2kzybhqqrhh4lfdl9nm0i62nd9jrvwinjp802qkffg2";
      type = "gem";
    };
    version = "0.3.0";
  };
  tty-which = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ki331s870p7j8yi58q8ig0gwy9kfgmjlq1jqs11h12mcm0mzi0a";
      type = "gem";
    };
    version = "0.4.2";
  };
  typogruby = {
    dependencies = ["rubypants"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j7kd1jlpa2n2xk5cm63yzj1fbvhralw6ca3zm1br5pn2r3pd82h";
      type = "gem";
    };
    version = "1.0.18";
  };
  uglifier = {
    dependencies = ["execjs"];
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wgh7bzy68vhv9v68061519dd8samcy8sazzz0w3k8kqpy3g4s5f";
      type = "gem";
    };
    version = "4.2.0";
  };
  w3c_validators = {
    dependencies = ["json" "nokogiri" "rexml"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j98x7byq6zzc5w00xqlwhbccv8s0x156s5f0fnfb4x6k0aq376i";
      type = "gem";
    };
    version = "1.3.6";
  };
  words_counted = {
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "735357e4d530c99d5c4c366d0c246ebffffd80de";
      sha256 = "0gdcdr1r22wssy6ryvmc1l2lyxn97z6qb1715maidq7yhllmr261";
      type = "git";
      url = "https://github.com/werthen/words_counted";
    };
    version = "1.0.2";
  };
  yui-compressor = {
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06x5r189vvy24yn41ndf94m0kgl8zcwxkr77bw7d2jz00wy46957";
      type = "gem";
    };
    version = "0.12.0";
  };
  zeitwerk = {
    groups = ["default" "development" "nanoc"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1746czsjarixq0x05f7p3hpzi38ldg6wxnxxw74kbjzh1sdjgmpl";
      type = "gem";
    };
    version = "2.4.2";
  };
}
