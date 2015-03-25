# cmdargsopts

A simple nim command line parsing module. Call parseCmdArgsOpts() and this will
initialized cmdArgs = Table[string, string] and cmdOpts = Table[string, string].

cmdOpts is a key value pair Table with the key being the short and long options. Those short options
begin with a single dash and are usually single character such as -o:3. Where as long options begin
with two dashes, such as --optimize:3.

cmdArgs is a key value pair Table with the the key being any argument that doesn't begin with a dash.
The value for is optional and the separator is either colon ":" or equal "=".
