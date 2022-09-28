# Manual 
'https://stedolan.github.io/jq/manual/'

# Tutorial
'https://stedolan.github.io/jq/tutorial/'

# Cookbook
'https://github.com/stedolan/jq/wiki/Cookbook'

#Cheatsheet
https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4

# Command man page: https://manpages.ubuntu.com/manpages/focal/man1/jq.1.html


# To pretty print the json:
jq "." < filename.json
cat filename.json | jq "."

# To access the value at key "foo":
jq '.foo'

# To access first list item:
jq '.[0]'

# to slice and dice:
jq '.[2:4]'
jq '.[:3]'
jq '.[-2:]'

# To merge JSON files
jq --slurp '.[0] * .[1]' file1 file2


# Sort array of objects by value(s)

cat sample.json | jq -s -c 'sort_by(.first_name) | .[]'

cat sample.json | jq -s -c 'sort_by(.first_name, .last_name) | .[]'

# -s "slurp" all inputs into an array; apply filter to it
# -c compact



# merge duplicates with "add" (+)
# (add is defined as def add: reduce .[] as $x (null; . + $x);, which iterates over the input array's/object's values and adds them. Object addition == merge.)
jq --slurp add '.[0] * .[1]' file1 file2

# Regexp
$ echo '[{"Address": "The Sq", "n": 1}, {"Address": "1 Bridge Rd", "n": 2}]' | \
  jq '.[] | select(.Address|test("^[0-9]"))'

# Take the docker images with names matching a regex:
docker image ls --format="{{json .}}" | jq '. | select(.Tag|test("^bm_.*"))'

# Take the docker images created since 2022-02-08
docker image ls --format="{{json .}}" | jq '. | select(.CreatedAt>="2022-02-08")'
# Take the docker images created since last month
docker image ls --format="{{json .}}" | jq '. | select(.CreatedAt<"'`date +%Y-%m-%d --date="last month"`'")'


# Delete images older than 1month matching a specific regex
docker image ls --format="{{json .}}" \
| jq '. | select(.CreatedAt<"'`date +%Y-%m-%d --date="last month"`'") | select(.Tag|test("^bm_.*")) | .ID' \
| xargs -I% docker image rm %


# Delete oldeer messatge TODO
docker image ls github/cadext* --format="{{json .}}"  | jq -s 'sort_by(.CreatedAt) | .[:-1] | .[] | select(.CreatedAt<"'`date +%Y-%m-%d --date="24 hours ago"`'") | .ID ' | xargs -I{} docker rmi {}

# Combine date and 

# Filter by date
.users[] | select (.last_login | . == null or fromdateiso8601 > 1475625600).id 



# from man jq
# Basic filter
Identity: .
       The absolute simplest filter is . . This is a filter that takes its input and produces  it
       unchanged as output. That is, this is the identity operator.

       Since  jq by default pretty-prints all output, this trivial program can be a useful way of
       formatting JSON output from, say, curl.

           jq ´.´
              "Hello, world!"
           => "Hello, world!"

   Object Identifier-Index: .foo, .foo.bar
       The simplest useful filter is .foo. When given a JSON object (aka dictionary or  hash)  as
       input, it produces the value at the key "foo", or null if there´s none present.

       A filter of the form .foo.bar is equivalent to .foo|.bar.

       This  syntax  only works for simple, identifier-like keys, that is, keys that are all made
       of alphanumeric characters and underscore, and which do not start with a digit.

       If the key contains special characters, you need to surround it with  double  quotes  like
       this: ."foo$", or else .["foo$"].

       For  example  .["foo::bar"]  and  .["foo.bar"] work while .foo::bar does not, and .foo.bar
       means .["foo"].["bar"].

           jq ´.foo´
              {"foo": 42, "bar": "less interesting data"}
           => 42

           jq ´.foo´
              {"notfoo": true, "alsonotfoo": false}
           => null

           jq ´.["foo"]´
              {"foo": 42}
           => 42

   Optional Object Identifier-Index: .foo?
       Just like .foo, but does not output even an error when . is not an array or an object.

           jq ´.foo?´
              {"foo": 42, "bar": "less interesting data"}
           => 42

           jq ´.foo?´
              {"notfoo": true, "alsonotfoo": false}
           => null

           jq ´.["foo"]?´
              {"foo": 42}
           => 42

           jq ´[.foo?]´
              [1,2]
           => []

   Generic Object Index: .[<string>]
       You can also look up fields of an object using syntax  like  .["foo"]  (.foo  above  is  a
       shorthand version of this, but only for identifier-like strings).

   Array Index: .[2]
       When the index value is an integer, .[<value>] can index arrays. Arrays are zero-based, so
       .[2] returns the third element.

       Negative indices are allowed, with -1 referring to the last element, -2 referring  to  the
       next to last element, and so on.

           jq ´.[0]´
              [{"name":"JSON", "good":true}, {"name":"XML", "good":false}]
           => {"name":"JSON", "good":true}

           jq ´.[2]´
              [{"name":"JSON", "good":true}, {"name":"XML", "good":false}]
           => null

           jq ´.[-2]´
              [1,2,3]
           => 2

   Array/String Slice: .[10:15]
       The .[10:15] syntax can be used to return a subarray of an array or substring of a string.
       The array returned by .[10:15] will be of length 5, containing the elements from index  10
       (inclusive) to index 15 (exclusive). Either index may be negative (in which case it counts
       backwards from the end of the array), or omitted (in which case it refers to the start  or
       end of the array).

           jq ´.[2:4]´
              ["a","b","c","d","e"]
           => ["c", "d"]

           jq ´.[2:4]´
              "abcdefghi"
           => "cd"

           jq ´.[:3]´
              ["a","b","c","d","e"]
           => ["a", "b", "c"]

           jq ´.[-2:]´
              ["a","b","c","d","e"]
           => ["d", "e"]

   Array/Object Value Iterator: .[]
       If  you  use  the  .[index] syntax, but omit the index entirely, it will return all of the
       elements of an array. Running .[] with the input [1,2,3] will produce the numbers as three
       separate results, rather than as a single array.

       You can also use this on an object, and it will return all the values of the object.

           jq ´.[]´
              [{"name":"JSON", "good":true}, {"name":"XML", "good":false}]
           => {"name":"JSON", "good":true}, {"name":"XML", "good":false}

           jq ´.[]´
              []
           =>

           jq ´.[]´
              {"a": 1, "b": 1}
           => 1, 1

   .[]?
       Like .[], but no errors will be output if . is not an array or object.

   Comma: ,
       If two filters are separated by a comma, then the same input will be fed into both and the
       two filters´ output value streams will be concatenated in order: first, all of the outputs
       produced  by  the  left expression, and then all of the outputs produced by the right. For
       instance, filter .foo, .bar, produces both the "foo" fields and "bar" fields  as  separate
       outputs.

           jq ´.foo, .bar´
              {"foo": 42, "bar": "something else", "baz": true}
           => 42, "something else"

           jq ´.user, .projects[]´
              {"user":"stedolan", "projects": ["jq", "wikiflow"]}
           => "stedolan", "jq", "wikiflow"

           jq ´.[4,2]´
              ["a","b","c","d","e"]
           => "e", "c"

   Pipe: |
       The  |  operator combines two filters by feeding the output(s) of the one on the left into
       the input of the one on the right. It´s pretty much the same as the Unix shell´s pipe,  if
       you´re used to that.

       If  the  one  on  the left produces multiple results, the one on the right will be run for
       each of those results. So, the expression .[] | .foo retrieves the  "foo"  field  of  each
       element of the input array.

       Note that .a.b.c is the same as .a | .b | .c.

       Note  too that . is the input value at the particular stage in a "pipeline", specifically:
       where the . expression appears. Thus .a | . | .b is the same as .a.b,  as  the  .  in  the
       middle refers to whatever value .a produced.

           jq ´.[] | .name´
              [{"name":"JSON", "good":true}, {"name":"XML", "good":false}]
           => "JSON", "XML"

   Parenthesis
       Parenthesis work as a grouping operator just as in any typical programming language.

           jq ´(. + 2) * 5´
              1
           => 15

