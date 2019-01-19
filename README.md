# HasMyGsuiteBeenPwned

**No longer maintained**   
**I recommend using Have I Been Pwned's [Domain Search feature](https://haveibeenpwned.com/DomainSearch) instead.**

This project allows G Suite admins to quickly check their entire G Suite directory (emails) against https://haveibeenpwned.com.
It uses OAuth 2 (Sign in with Google) and allows you to see which of your users have possibly had their accounts breached.

The project currently supports signing in with Google, retrieving the entire G Suite directory, and checking individual emails against Have I Been Pwned.
It all happens under the hood at the moment with no UI for anything.

## Blockers

* [Issue #1](https://github.com/obahareth/has-my-gsuite-been-pwned/issues/1).

## TODO

* Handle cases where non-G Suite users try to use the service
* Handle cases where people without the necessary G Suite permissions try to use the service (Google might be handling this one for us because we sign in and request the relevant permissions).
* Generate CSV report.
* Have the report generation happen in the background (a simple `Task` might suffice).
* Upload report to Google Cloud Storage (and set it to expire after 3 days)
* Send email report using Mailgun containing link to CSV.
