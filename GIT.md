# Git Cheats

## Settings

```sh
git config --list
```

(stored in: `~/.gitconfig`)

## 📂 Repositories

Create a new repository on GitHub.

### Push existing, local repo to GitHub

```sh
git init
git add FNAME(S)
git commit -m “MSG”
```

### Push Repo to GitHub

1. Create repo on GitHub, don't add README, etc
2. Click Create
3. Follow instructions on next page
   ```sh
   git remote add origin REPO-URL
   git branch -M main
   git push -u origin main
   ```

### Clone

Private repo:

```sh
git clone https://username@github.com/repo.git
```

## 🪵 Branches

### List branches

```sh
git branch -l # local
git branch -a # remote + local
```

### New branch

```sh
git checkout -b BRANCH-NAME [optional: PARENT-BRANCH ]
```

then push to remote:

```sh
git push -u origin BRANCH-NAME
```

### Checkout branch

```sh
git checkout BRANCH-NAME
```

### Rename

Locally

```sh
git branch -m NEW-NAME               # current branch
git branch -m OTHER-BRANCH NEW-NAME  # other branch
```

### Detail Info

Get current branch

```sh
git branch
```

Commit hash

```sh
git rev-parse HEAD          # long
git rev-parse --short HEAD  # short
```

Get parent branch

```sh
git log --graph --decorate
```

Get target branch for push or fetch

```sh
git remote -v
```

Double checking where a push would end up:

```sh
git push --dry-run
```

### Delete

```sh
git branch -D BRANCH-NAME             # Locally
git push origin --delete BRANCH-NAME  # Remote
```

### Clean up

Remove local branches that no longer exist on remote:

1. Update list of branches (fetches info from remote)
   ```sh
   git fetch -p
   ```
2. Remove all local branches with status "merged"
   ```sh
   git branch --merged origin/main | grep -v main | xargs git branch -D
   ```
3. Removes all local branches with status "gone"; this will keep currently working on branches.
   ```sh
   git branch -vv | grep ': gone]'| grep -v “\*” | awk '{ print $1; }' | xargs -r git branch -D
   ```

To preview the branches: remove the `| xargs ..` part

## 🤝 Merge

1. Fetch/pull on BOTH branches
2. Checkout current branch
3. Merge
   ```sh
   git merge --no-commit --no-ff OTHER-BRANCH
   ```
   where
   - `no-commit` means don’t commit the changes yet
   - `no-ff` means no fast-forward

Abort merge:

```sh
git merge --abort
```

## ✍️ Changes

### Compare

```sh
git diff BRANCH-A..BRANCH-B
git diff BRANCH-A..BRANCH-B --stat          # file overview only
```

### Fetch latest changes

```sh
git fetch -p
```

### Pull changes

```sh
git pull                                    # from origin
git checkout OTHER-BRANCH -- FNAME(S)       # from other branch
```

### List changes (fetch first):

```sh
git fetch -p && git status
```

### Discard changes

```sh
git checkout -- . FNAME(S)
git reset --hard                           # resets all changes
```

where:

- `.` current branch (latest commit)
- `FNAME(S)` which file(s) to discard

## 🏋️ Push

Flow:

1. Add (stage) to commit = Staged changes
2. Commit
3. Push to remote

### 1. Add / Stage

```sh
git add
    -a (all files)
    FNAME(S) (specific file(s))
    -p FNAME (specific hunk(s))
```

Revert add

```sh
git restore --staged
    . (for all)
    FNAME(S) (specific file(s))
```

### 2. Commit

```sh
git commit -m "MSG"
```

Modify message afterwards:

```sh
git commit --amend -m "NEW-MSG"
```

#### Revert

```sh
git reset HEAD~
```

--> moves latest commit changes back into list

Use old commit message after revert

```sh
git commit -c ORIG_HEAD # reset copies old head into .git/ORIG_HEAD)
```

#### Show commit(s)

See local changes wrt to remote

```sh
git log origin/BRANCH-NAME..HEAD
```

See local changes wrt remote (includes staged changes)

```sh
git diff --cached origin/BRANCH-NAME --stat
```

- `--stat` to see a file overview only

### 3. Push

```sh
git push
```

Double checking where a push would end up:

```sh
git push --dry-run
```

#### Push failures

If push fails because of a missing pull first:

```sh
git pull --no-rebase
git commit (same as above)
git push
```

Pull command creates a merge which opens a VIM Editor. Press ESC + ZZ to save and exit

If push fails because of no remote branch yet:

```sh
git push -u origin HEAD
```

#### Revert

Revert, but visible in history (`+` for force push)

```sh
git push origin +PREV-COMMIT-ID:BRANCH-NAME
```

Revert to specific commit and remove commit from history

```sh
git reset PREV-COMMIT-ID --hard
git push origin/BRANCH-NAME -f
```

Revert changes to file / folder by using a different branch’s state:

```sh
git checkout OTHER-BRANCH FOLDER
```

## 🍒 Cherry Picking

= arbitrarily pick commits from other branches - or to revert when committed to the wrong branch
https://www.atlassian.com/git/tutorials/cherry-pick

```sh
git cherry-pick COMMIT-SHA [--no-commit]
```

:warning: commits changes immediately iff no issue --> add `--no-commit`

Edit picked commit before committing:

```sh
git cherry-pick --edit COMMIT-SHA
```

If issues arise by applying changes:

- Resolve issues
- then:
  ```sh
  git add FNAME
  git cherry-pick --continue
  ```

Abort cherry picking:

```sh
git cherry-pick --abort
```

## 📦 Stashes

```sh
git stash list
```

### Send to stash

All files:

```sh
git stash                   # without description
git stash push -m "MSG"     # with
```

Specific file(s)

```sh
git stash -- FNAME(S)               # without description
git stash push -m "MSG" FNAME(S)    # with
```

### Get from stash

Pull in changes, but keep stash

```sh
git stash apply                  # latest stash
git stash apply stash@{INDEX}    # specific stash
```

Pull in changes, remove from stash

```sh
git stash pop                   # latest stash
git stash pop stash@{INDEX}     # specific stash
```

Pull specific file(s) from stash

```sh
git checkout stash@{INDEX} -- FNAME(S)
```

Remove stash

```sh
git stash drop                   # latest stash
git stash drop stash@{INDEX}     # specific stash
```

Show stash changes
Last:

```sh
git stash show stash@{INDEX}
```

Detailed overview

```sh
git stash show -p
```

or (with potentially better format):

```sh
git stash list | awk -F: '{ print "\n\n\n\n"; print $0; print "\n\n"; system("git stash show -p " $1); }'
```

Rename stash

1. Drop specific stash
   ```sh
    > git stash drop stash@{INDEX}
    Dropped stash@{INDEX} (STASH-ID)
   ```
2. Re-add with new name:
   ```sh
     git stash store -m “New name” STASH-ID
   ```

## 🏆 Releases

List all release tags (local):

```sh
git tag
```

Remove all release tags
First remotely, then locally

```sh
git tag | xargs -L 1 | xargs git push origin --delete
git tag | xargs -L 1 | xargs git tag --delete
```

## 🏴‍☠️ Submodules

= link repo (B) in repo (A)

### Add new

Within target repo (repoA), run

```sh
git submodule add https://github.com/repo.git
git status  # optional, check if .gitmodules was modified
```

If this fails:

- make sure no entry in `.gitmodules`, `.git/config` and no folder in `.git/modules/repoA/repoB`

### Clone repo w/ submodules

```sh
git pull REPO
cd SUBMODULE
git submodule init
git submodule update
```

Switch branch for submodule:

```sh
# in repoA
cd repoB
git checkout BRANCH-NAME
```
