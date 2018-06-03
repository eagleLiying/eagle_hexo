hexo generate
cp -R public/* deploy/eagleLiying.github.io
cd deploy/eagleLiying.github.io
git add .
git commit -m “update blog”
git push origin master