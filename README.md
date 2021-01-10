# Scripts_101

## How To sync your forked repository
```
$ git fetch --all --prune
$ git checkout master
$ git reset --hard upstream/master
$ git push origin master
```