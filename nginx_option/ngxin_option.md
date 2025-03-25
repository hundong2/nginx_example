# nginx option

## 1. nginx health check option

- [example config](./nginx_health_check.conf)  

```sh
stream {
    server {
        listen 1234;
        proxy_pass stream_backend;
        health_check interval=10s passes=2 fails=3; #2 회 연속 성공 시 healthcheck pass, 3회 연속 실패 시 healthcheck fail 
        health_check_timeout 5s;
    }
}
```

- [example site - HTTP health check](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check)  
- 