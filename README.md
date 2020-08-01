# Prashna

This is a __Quora-clone__ but with credit system, based on Ruby on Rails Framework.

* **Rails version**    : 6.0.2.2
* **Ruby version**     : ruby 2.7.0p0 (2019-12-25 revision 647ee6f091) [x86_64-linux]
* **Database adapter** : psql, switch to branch master for mysql

### Configurations

After installing all the dependencies, configure the application.yml and database.yml files.

> Those '.yml' files have corresponding '.yml.example' files attached
> with them, to get started with sample configurations.

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
