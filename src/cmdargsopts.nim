import parseopt2, strutils, tables, pegs, os
export tables

const
  DBG = false

# Note: we shouldn't have to repeat "initOrderedTable[string, string]" 4 times
# but I don't know how to do it "right"

var
  # Tables of key, value pairs
  cmdArgs* = initOrderedTable[string, string]()
  cmdOpts* = initOrderedTable[string, string]()

proc parseCmdArgsOpts*(cmdLine: seq[string]) =
  ## parse the command line using parseopt2 creating two tables,
  ## cmdArgs and cmdOpts. cmdOpts constains the key value pairs
  ## of both the short and long options and cmdArgs contains all
  ## other arguments. For cmdArgs the first ":" or "=" is used
  ## to separate the key value pair and if there is none the value
  ## is the empty string.

  var parser: OptParser

  # clear the tables
  if cmdArgs.len != 0:
    cmdArgs = initOrderedTable[string, string]()
  if cmdOpts.len != 0:
    cmdOpts = initOrderedTable[string, string]()

  # Initialize the parser
  when DBG: echo "cmdLine=", cmdLine
  parser = initOptParser(cmdLine)

  # loop going through the arguments and options saving them to the table
  while true:
    parser.next()
    var
      kind = parser.kind
      key = parser.key
      val = parser.val
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
    of cmdEnd:
      when DBG: echo "cmdEnd: done"
      break
    else:
      when DBG: echo "unknown kind=", kind
      discard

proc parseCmdArgsOpts*() =
  parseCmdArgsOpts(commandLineParams())
