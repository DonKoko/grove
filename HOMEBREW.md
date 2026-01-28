# Setting Up Homebrew Tap for Grove

To enable `brew install grove`, you need to create a Homebrew tap (a separate GitHub repository).

## Step 1: Create the tap repository

Create a new GitHub repository named `homebrew-grove` (the `homebrew-` prefix is required).

## Step 2: Add the formula

Copy `Formula/grove.rb` to the root of your `homebrew-grove` repository.

## Step 3: Create a release

In the main `grove` repository:

1. Tag a release:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. Create a GitHub release from the tag

3. Get the tarball URL and SHA256:
   ```bash
   # Download the tarball
   curl -L -o grove.tar.gz https://github.com/donkoko/grove/archive/refs/tags/v1.0.0.tar.gz
   
   # Get SHA256
   shasum -a 256 grove.tar.gz
   ```

4. Update `grove.rb` in your `homebrew-grove` repo with the actual SHA256

## Step 4: Test it

```bash
brew tap donkoko/grove
brew install grove
```

## Updating

When you release a new version:

1. Create a new tag and release in the main repo
2. Update the version and SHA256 in `homebrew-grove/grove.rb`
3. Users update with `brew upgrade grove`

## Directory Structure

You'll end up with two repositories:

```
# Main repository
github.com/donkoko/grove
├── bin/gwt
├── completions/
├── integrations/
├── Formula/grove.rb  (reference copy)
├── install.sh
├── README.md
└── ...

# Homebrew tap repository  
github.com/donkoko/homebrew-grove
└── grove.rb  (the actual formula Homebrew uses)
```
