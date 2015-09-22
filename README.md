# hubot-bugzilla

A hubot script that shows bug details from bugzilla.

See [`src/bugzilla.coffee`](src/bugzilla.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-bugzilla --save`

Then add **hubot-bugzilla** to your `external-scripts.json`:

```json
[
  "hubot-bugzilla"
]
```

## Sample Interaction

```
user1>> Check out bug 689423
hubot>> Bug https://bugzilla.mozilla.org/show_bug.cgi?id=689423 normal, NEW, Add Angry Birds to Firefox new tab page
```
