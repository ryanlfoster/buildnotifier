Build Notifier
==============

Development & Deployment
-----------

1.  Install and start `monogodb`

2.  Copy config/application.yml.example to config/application.yml and config/mongoid.yml.example. Change their configuration according to your environment. 

3.  Configure paperclip options. It uses s3 storage as default and copy config/s3.yml.example to config/s3. If you use other storage, please modify config/initializers/paperclip_storage_options.rb accordingly.

4.  Run `bundler`, place exclude groups not for your environment, e.g.,

        $ bundle install --without linux_development # for Mac
        $ bundle install --without mac_development # for Linux


5.  Setup database `rake db:setup`

6.  Test is setup using RSpec, Steak, Factory Girl.

7.  Enjoy `guard`
