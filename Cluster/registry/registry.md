docker run -d -p 5000:5000 --restart=always --name registry registry:2


docker tag $IMAGE $REGISTRY/$IMAGE

docker push $REGISTRY/$IMAGE


aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 334716479543.dkr.ecr.us-east-2.amazonaws.com