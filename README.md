# README

1. Reason for rails api: brightwheel is a rails shop :)

2. Setup:
 Please follow standard rails setup, `bundle` first, then `rake db:create`
 To set up mailer, the app expect ENV variables for mailer user name and password. One way you can load the credentials is by creating `.env` file and add things like
 ```
  MAILGUN_USER="****"
  MAILGUN_PW="*****"
  MANDRILL_USESR="********"
  MANDRILL_PW="*******"
 ```
 post request to `/email` will provide stack trace in development to help debug if something goes wrong. Please remember to include a "secret" token set to `token: "yeswearebright"` in your request. Otherwise you will run into authentication error. Stack traces will be masked for production.
 
3. Switching/adding email services:
  You can change default email service simply by update the `default_email_service` value in settings.yml and redeploy.
  To add/remove email services, simply add appropriate ENV credentials and add settings to the settings.yml file.
 
4. Tests:
  Simply run `rspec spec/`.
  
5. Improvements:
  If there are more time, few more things would be nice to address:
  - auth token for the post request should probably be generated as API key and secret of some sort.
  - send to email address should be validated with the existing user database.
  - move email service credential and settings to database to manage as it allows switching default provider without redeploy
  - set up monitor to email service provider status and change default email service in database when status page report. outage or we receive too many errors.
  - email deliver probably can be delivered by worker instead of immediately.
  - create API documentation


Please don't hesitate to ask if you have questions!
