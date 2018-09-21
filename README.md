# HasMyGsuiteBeenPwned

**This project's development is on hold until a solution to the blocker below is found**

This project allows G Suite admins to quickly check their entire G Suite directory (emails) against https://haveibeenpwned.com.
It uses OAuth 2 (Sign in with Google) and allows you to see which of your users have possibly had their accounts breached.

The project currently supports signing in with Google, retrieving the entire G Suite directory, and checking individual emails against Have I Been Pwned.
It all happens under the hood at the moment with no UI for anything.

## Blockers

* `https://haveibeenpwned.com`'s rate limits are a major blocker, waiting for them + an added 150ms still doesn't seem to be enough, and there's no simple way to work around them (we'd be asynchronously checking multiple entire G Suite directories, and we'd have to keep a "rate limit state" to make sure we are always using the most recent rate limit). A possible super ugly solution would be to only allow one directory to be checked at at time, therefore we don't have to worry about rate limit state.

## TODO

* Handle cases where non-G Suite users try to use the service
* Handle cases where people without the necessary G Suite permissions try to use the service (Google might be handling this one for us because we sign in and request the relevant permissions).
* Generate CSV report.
* Have the report generation happen in the background (a simple `Task` might suffice).
* Upload report to Google Cloud Storage (and set it to expire after 3 days)
* Send email report using Mailgun containing link to CSV.
