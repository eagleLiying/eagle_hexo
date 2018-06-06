# 克隆
git clone https://github.com/eagleLiying/eagleLiying.github.io.git

hexo generate
cp -R public/* eagleLiying.github.io
cd eagleLiying.github.io
git add .
git commit -m “update blog”
git push origin master