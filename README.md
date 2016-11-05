# Papersist

**Persisting Papers** since sometime in the future.

A little diddy that [DailyDrip](http://dailydrip.com) is putting together to
help [@knewter](http://github.com/knewter) keep a solid feed of Computer Science
papers flowing into a yet-to-be-developed categorization and moderation queue.

## Release

To build a release:

```sh
# For dev
mix release --verbose
# For prod
MIX_ENV=prod mix release --env=prod --verbose
```

There's also a [papersist.service](./papersist.service) file that defines a
systemd service definition for the release.
