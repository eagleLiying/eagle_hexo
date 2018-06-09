mkdir .deploy
cd .deploy
# 克隆
git clone https://github.com/eagleLiying/eagleLiying.github.io.git
cd ..
hexo generate
cp -R public/* .deploy/eagleLiying.github.io
cd  .deploy/eagleLiying.github.io
git add .
git commit -m “update blog”
git push origin master