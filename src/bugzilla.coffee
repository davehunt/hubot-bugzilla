# Description:
#   Displays bug details from bugzilla
#
# Configuration:
#   HUBOT_BUGZILLA_URL
#   HUBOT_BUGZILLA_IGNORE_USERS (optional regular expression of users to ignore)
#
# Commands:
#   bug <number> - details of the bug will be shown
#
# Notes:
#   None
#
# Author:
#   Dave Hunt <dave.hunt@gmail.com>

bugzillaURL = process.env.HUBOT_BUGZILLA_URL
ignoreUsers = process.env.HUBOT_BUGZILLA_IGNORE_USERS

unless bugzillaURL?
  console.log "Missing HUBOT_BUGZILLA_URL in environment: please set and try again"
  process.exit(1)

module.exports = (robot) ->
  robot.hear /\bbug[\s\#\-]+(\d+)\b/i, (res) ->
    if ignoreUsers and res.message.user.name.match(new RegExp(ignoreUsers, "gi"))
      return
    bugID = res.match[1]
    bugURL = "#{bugzillaURL}/show_bug.cgi?id=#{bugID}"
    robot.http("#{bugzillaURL}/rest/bug?id=#{bugID}")
      .header('Accept', 'application/json')
      .get() (err, response, body) ->
        if err
          error res, bugURL, err
          return
        if response.statusCode isnt 200
          sendError res, bugURL, "Invalid status code (#{res.statusCode})"
          return
        try
          data = JSON.parse body
        catch error
          sendError res, bugURL, "Unable to parse JSON"
          return
        if data.bugs.length is 0
          sendError res, bugURL, "Bug not found"
          return
        bug = data.bugs[0]
        bugStatus = bug.status
        if bug.resolution isnt ""
          bugStatus += " #{bug.resolution}"
        res.send "Bug #{bugURL} #{bug.severity}, #{bugStatus}, #{bug.summary}."

  sendError = (res, url, message) ->
    res.send "Error: #{message}. You can try accessing the bug directly at #{url}"
