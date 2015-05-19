rm -rf apps config
cp -rp ../../apps .
cp -rp ../../config .
docker build --rm -t monad-cloud .
rm -rf apps config
