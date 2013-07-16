Build Notifier
==============

Development
-----------

1.  Install and start `monogodb`
2.  Run `bundler`, place exclude groups not for your environment, e.g.,

        $ bundle install --without linux_development # for Mac
        $ bundle install --without mac_development # for Linux

3.  Setup database `rake db:setup`
4.  Test is setup using RSpec, Steak, Factory Girl.
5.  Enjoy `guard`
