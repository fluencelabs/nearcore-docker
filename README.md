## How to build
```sh
export VERSION=1.31.0-rc.3
docker build -t fluencelabs/nearcore:$VERSION --build-arg=NEAR_VERSION=$VERSION .
```
