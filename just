---
syntax: bash
tags: [ dev ]
---

# Format file
just --fmt --unstable

# Print value of a variable
just --evaluate foo

# Example with:
#     Run other recipes
#       > before
#       > during
#       > after
#     arguments with default values
#       > as env vars
#       > as just vars
```
entry-recipe inputArg="world" $varAsEnv="hello": run-before && run-after
    echo "$varAsEnv {{inputArg}}";
    just run-middle
    echo "bye";
```

# Open chooser by default 
#   (no-cd is required if one of the options requries [no-cd])
```
# Open fzf picker
[no-cd]
default:
    @just --choose
```

# Useful variables
```
date := `TZ='Europe/Berlin' date +"%Y%m%d_%H%M%S"`
gitrepo := `basename $(git rev-parse --show-toplevel)`
gitbranch := `git rev-parse --abbrev-ref HEAD`
gitcommit-full := `git rev-parse HEAD`
gitcommit := `git rev-parse --short HEAD`
```
