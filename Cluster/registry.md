docker run -d -p 5000:5000 --restart=always --name registry registry:2


docker tag $IMAGE $REGISTRY/$IMAGE

docker push $REGISTRY/$IMAGE