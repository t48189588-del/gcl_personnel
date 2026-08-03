# Make sure you're on main
git checkout main

# Build the Flutter web app
cd sharepoint_reservation_app

flutter build web \
    --release \
    --base-href /gcl_personnel/reservation/

cd ..

# Create a staging directory
rm -rf publish
mkdir publish

# Copy the main website into the staging directory
rsync -av \
    --exclude publish \
    --exclude .git \
    --exclude sharepoint_reservation_app \
    --exclude build \
    ./ publish/

# Copy the Flutter build into /reservation
mkdir -p publish/reservation
cp -R sharepoint_reservation_app/build/web/* publish/reservation/

# Add a .nojekyll file
touch publish/.nojekyll

# Create gh-pages branch if it doesn't already exist
git show-ref --verify --quiet refs/heads/gh-pages || git branch gh-pages

# Create a worktree for the gh-pages branch
rm -rf /tmp/gcl_personnel-gh-pages
git worktree add /tmp/gcl_personnel-gh-pages gh-pages

# Remove old published files
find /tmp/gcl_personnel-gh-pages -mindepth 1 -maxdepth 1 \
    ! -name ".git" \
    -exec rm -rf {} +

# Copy the new site
cp -R publish/* /tmp/gcl_personnel-gh-pages/

cd /tmp/gcl_personnel-gh-pages

git add .

git commit -m "Deploy $(date '+%Y-%m-%d %H:%M:%S')" || echo "Nothing to commit"

git push --force origin gh-pages

cd -

# Clean up
git worktree remove /tmp/gcl_personnel-gh-pages

rm -rf publish