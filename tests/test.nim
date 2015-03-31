import cmdargsopts, unittest, tables, sequtils

suite "test cmdargsopts":
  test "no params":
    parseCmdArgsOpts(@[])
    check((cmdArgs.len == 0))
    check((cmdOpts.len == 0))

  test "one argument no value":
    parseCmdArgsOpts(@["a"])
    check(cmdArgs.len == 1)
    check(cmdArgs["a"] == "")
    check(cmdOpts.len == 0)

  test "multiple arguments no value":
    parseCmdArgsOpts(@["first", "second"])
    check(cmdArgs.len == 2)
    check(cmdArgs["first"] == "")
    check(cmdArgs["second"] == "")
    check(cmdOpts.len == 0)
    # check that its ordered
    var k = toSeq(keys(cmdArgs))
    check(k[0] == "first")
    check(k[1] == "second")

  test "one argument with value and '=' seperator":
    parseCmdArgsOpts(@["a=1"])
    check(cmdArgs.len == 1)
    check(cmdArgs["a"] == "1")
    check(cmdOpts.len == 0)

  test "one argument with value and ':' seperator":
    parseCmdArgsOpts(@["a:1"])
    check(cmdArgs.len == 1)
    check(cmdArgs["a"] == "1")
    check(cmdOpts.len == 0)

  test "one argument with bogus '+' seperator":
    parseCmdArgsOpts(@["a+1"])
    check(cmdArgs.len == 1)
    check(cmdArgs["a+1"] == "")
    check(cmdOpts.len == 0)

  test "multiple arguments with various keys, seperators and values":
    parseCmdArgsOpts(@["first:one", "second:one two", "three=1 2 3"])
    check(cmdArgs.len == 3)
    check(cmdArgs["first"] == "one")
    check(cmdArgs["second"] == "one two")
    check(cmdArgs["three"] == "1 2 3")
    check(cmdOpts.len == 0)

  test "one short option":
    parseCmdArgsOpts(@["-l:1"])
    check(cmdArgs.len == 0)
    check(cmdOpts.len == 1)
    check(cmdOpts["l"] == "1")

  test "multiple short options":
    parseCmdArgsOpts(@["-l:1", "-m:a b c"])
    check(cmdArgs.len == 0)
    check(cmdOpts.len == 2)
    check(cmdOpts["l"] == "1")
    check(cmdOpts["m"] == "a b c")

  test "one long option":
    parseCmdArgsOpts(@["--long:1"])
    check(cmdArgs.len == 0)
    check(cmdOpts.len == 1)
    check(cmdOpts["long"] == "1")

  test "multiple long options mixed separators":
    parseCmdArgsOpts(@["--BIG:1", "--Small=a B c"])
    check(cmdArgs.len == 0)
    check(cmdOpts.len == 2)
    check(cmdOpts["BIG"] == "1")
    check(cmdOpts["Small"] == "a B c")

  test "multiple arguments, short and long options mixed separators":
    parseCmdArgsOpts(@["a=1", "--BIG:1", "beTheir=I'll come over", "-l:1", "--Small=a B c"])
    check(cmdArgs.len == 2)
    check(cmdArgs["a"] == "1")
    check(cmdArgs["beTheir"] == "I'll come over")
    check(cmdOpts.len == 3)
    check(cmdOpts["BIG"] == "1")
    check(cmdOpts["Small"] == "a B c")
    check(cmdOpts["l"] == "1")

  test "ordering":
    parseCmdArgsOpts(@["5", "-z:z", "--long:aLong", "3", "2", "4", "1", "-s:d"])
    var k = toSeq(keys(cmdArgs))
    check(k[0] == "5")
    check(k[1] == "3")
    check(k[2] == "2")
    check(k[3] == "4")
    check(k[4] == "1")
    k = toSeq(keys(cmdOpts))
    check(k[0] == "z")
    check(k[1] == "long")
    check(k[2] == "s")
