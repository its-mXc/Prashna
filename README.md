# Prashna

This is a __Quora-clone__ but with credit system, based on Ruby on Rails Framework.

* **Rails version**    : 6.0.2.2
* **Ruby version**     : ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux]
* **Database adapter** : postgresql, switch to branch master for mysql

## Configurations

After installing all the dependencies, configure the application.yml and database.yml files.

> Those '.yml' files have corresponding '.yml.example' files attached
> with them, to get started with sample configurations.

## Features

* **Login/Signup** - Signup with email, and login with email after confirming the account by email and get certain amount of credits to ask questions. Also supoorts forgot password via email.

* **Questions** - User can ask questions in markdown format, need certain credits in account(which can be configured in application.yml), if required credits not available it is saved in draft and can be published when required
* **Topic** - Questions when asked can be tagged for topics, and user can browse questions by particular topic
* **Comments/Answers** - User can answer questions or comment on it. User can also comment on answers and comments too.
* **Upvote/Downvote** - User can upvote/downvote questions, comments, and answers unless it is self authored.
* **Popular Answers** - If an answer is popular, i.e. it has certain amount of votes(application.yml), user get certain amount of credits(application.yml). Also if the answer loses popular status, the credits awarded gets reverted
* **Search** - User can search questions by thier title or topic 
* **Credit Packs** - User can buy credit packs , which award credits after successfull transaction
* **Follow** - User can follow other user or unfollow, can also browse other user account, and see thier questions, answers, following and followers. User can browse question, asked by the users they follow
* **Report Abuse** - User can report questions, answers, comments and if the abuse report for specific enity passes threshold limit(application.yml), and the transaction associated gets reverted
* **Api** - Two apis are supported, to get feed for specific user(need auth token), or get questions, related answers and comments for specific topic
* **Admin** - Admin can disable user, unpublish question, refund transaction and manage credit packs
* **Notification** - Notifications are generated when someone comments on question, answer. Email notifications are sent when someone answers user question, or after succesful payemnt, reciept is sent by email

## Rake Tasks
### New Admin

Make the new admins with the rake task using:

```sh
$ rake admin:new
```
### Clear IP activity

Make the new admins with the rake task using:

```sh
$ rake clean_ip_activity
```
