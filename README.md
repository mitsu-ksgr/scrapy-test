Python scrapy Test
==================

python3 で scrapy を使うテスト

### cf.
- https://scrapy.org/


### notes
```bash
# Run on docker
% docker build -t python-scrapy-test:latest .
% docker run --rm \
  -v "$(pwd)/out":/out \
  -t python-scrapy-test:latest \
  runspider --output=/out/out.json --output-format=json --loglevel=WARN /src/test.py

# Run use run.sh
% ./run.sh runspider /src/test.py
% cat ./out/out.json
```
