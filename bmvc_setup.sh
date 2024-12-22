docker container stop mybmvci
docker build -t bmvci .
docker run -d --rm --name mybmvci -p 8080:8080 -v $(pwd):/app bmvci
