import httpclient, json

let
  url = "https://data.cityofchicago.org/resource/x8fc-8rcq.json"
  client = newHttpClient()
  body = client.getContent(url)
  libraries = parseJson(body)

var
  history: seq[int]
  code: string

proc print_library(iter: int, library: int) =
  let
    l = libraries[library]

  if iter < 10:
    echo(iter, ".  ", l["name_"].getStr)
  else:
    echo(iter, ". ", l["name_"].getStr)


  if l.contains("hours_of_operation"):
    echo("    ", l["hours_of_operation"].getStr)
  echo("    ", l["address"].getStr)
  echo("    ", l["city"].getStr, " - ", l["zip"].getStr)
  echo("    ", l["website"]["url"].getStr)
  if l.contains("phone"):
    if l["phone"].getStr[0] == '(':
      echo("    ", l["phone"].getStr)

while true:
  stdout.write "> Please enter your zip code: "

  code = readline(stdin)

  if code == "history":
    if history.len == 0:
      echo ("No history yet.")
      continue

    var j = 0
    for i in countdown(history.len-1, 0):
      j += 1
      print_library(j, history[i])

  elif code == "exit":
    quit(QuitSuccess)

  else:
    var j = 0
    for i in 0..libraries.len - 1:
      if libraries[i]["zip"].getStr == code:
        j += 1
        history.add(i)
        print_library(j, i)

    if j == 0:
      echo "Not Found"
