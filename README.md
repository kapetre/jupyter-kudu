## Jupyter Notebook connecting to kerberized Kudu

Build
```
docker build -t jupyter-kudu:1.0.0 .
```

Run
```
docker run -itd \
--name jupyter \
-p 8888:8888 \
-v /etc/krb5.conf:/etc/krb5.conf \
-e NOTEBOOK_TOKEN='set_some_password' \
jupyter-kudu:1.0.0
```
