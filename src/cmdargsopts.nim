import parseopt2, strutils, tables, pegs
export tables

const
  DBG = false

var
  # Tables of key, value pairs
  cmdArgs* = initTable[string, string]()
  cmdOpts* = initTable[string, string]()

proc parseCmdArgsOpts*() =
  ## parse the command line using parseopt2 creating two tables,
  ## cmdArgs and cmdOpts. cmdOpts constains the key value pairs
  ## of both the short and long options and cmdArgs contains all
  ## other arguments. For cmdArgs the first ":" or "=" is used
  ## to separate the key value pair and if there is none the value
  ## is the empty string.
  for kind, key, val in getopt():
    case kind:
    of cmdShortOption, cmdLongOption:
      when DBG: echo "cmd{Short|Long}Option: key=", key, " val=", val
      cmdOpts[key] = val
    of cmdArgument:
      # Split cmdArgument at the first ":" or "/"
      var px = peg"':'/'='"
      var args = split(key, px)
      when DBG: echo "cmdArgument: args=", args
      if args.len == 2:
        cmdArgs[args[0]] = args[1]
      elif args.len == 1:
        cmdArgs[args[0]] = ""
      else:
        when DBG: echo "cmdArgument: unknown len=", args.len
        discard
    else:
      when DBG: echo "unknown kind=", kind
      discard

