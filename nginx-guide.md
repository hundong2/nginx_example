# 🚀 완전한 Nginx 가이드: 초보자에서 전문가까지

이 가이드는 nginx를 처음 접하는 초보자부터 전문가 수준까지 단계별로 학습할 수 있도록 구성되었습니다. 모든 예제는 Docker 환경에서 바로 실행 가능합니다.

## 📋 목차

1. [시작하기 전에](#시작하기-전에)
2. [레벨 1: 기초 (Beginner)](#레벨-1-기초-beginner)
3. [레벨 2: 중급 (Intermediate)](#레벨-2-중급-intermediate)
4. [레벨 3: 고급 (Advanced)](#레벨-3-고급-advanced)
5. [레벨 4: 전문가 (Expert)](#레벨-4-전문가-expert)
6. [참고 자료](#참고-자료)

## 시작하기 전에

### 필요한 도구
- Docker 및 Docker Compose
- 텍스트 에디터
- 웹 브라우저

### 저장소 구조
```
nginx_example/
├── nginx-guide.md                 # 이 가이드 문서
├── examples/
│   ├── beginner/                  # 레벨 1 예제들
│   ├── intermediate/              # 레벨 2 예제들
│   ├── advanced/                  # 레벨 3 예제들
│   └── expert/                    # 레벨 4 예제들
├── docker-compose.yml             # 메인 Docker Compose 파일
└── html/                          # 예제용 웹 콘텐츠
```

### 빠른 시작
```bash
# 저장소 클론
git clone <repository-url>
cd nginx_example

# 기본 예제 실행
docker-compose up -d

# 브라우저에서 http://localhost 확인
```

---

## 레벨 1: 기초 (Beginner)

### 1.1 nginx란 무엇인가?

nginx(엔진엑스)는 고성능 웹 서버이자 리버스 프록시 서버입니다.

**주요 특징:**
- 비동기 이벤트 기반 아키텍처
- 높은 동시 접속 처리 능력
- 낮은 메모리 사용량
- 웹 서버, 프록시 서버, 로드 밸런서 역할

### 1.2 기본 설정 파일 구조

```nginx
# nginx.conf 기본 구조
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name localhost;
        
        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
}
```

### 1.3 실습 1: 기본 웹 서버 설정

**목표:** 간단한 정적 웹 사이트 호스팅

**디렉토리:** `examples/beginner/01-basic-server/`

1. **설정 파일 확인**
   ```bash
   cd examples/beginner/01-basic-server/
   cat nginx.conf
   ```

2. **Docker로 실행**
   ```bash
   docker-compose up -d
   ```

3. **결과 확인**
   - 브라우저에서 `http://localhost:8001` 접속
   - "Hello, nginx!" 메시지 확인

4. **로그 확인**
   ```bash
   docker-compose logs nginx
   ```

### 1.4 실습 2: 여러 도메인 호스팅 (Virtual Hosts)

**목표:** 하나의 nginx로 여러 웹사이트 호스팅

**디렉토리:** `examples/beginner/02-virtual-hosts/`

**핵심 개념:**
- `server_name` 지시어
- 여러 `server` 블록

```nginx
# 예제 설정
server {
    listen 80;
    server_name site1.local;
    root /var/www/site1;
    index index.html;
}

server {
    listen 80;
    server_name site2.local;
    root /var/www/site2;
    index index.html;
}
```

### 1.5 실습 3: 기본 보안 헤더

**목표:** 웹사이트 보안 강화

```nginx
server {
    listen 80;
    server_name localhost;
    
    # 보안 헤더 추가
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

### 1.6 레벨 1 체크리스트

- [ ] nginx 기본 개념 이해
- [ ] 설정 파일 구조 파악
- [ ] 기본 웹 서버 설정 및 실행
- [ ] Virtual Hosts 설정
- [ ] 기본 보안 헤더 적용
- [ ] 로그 확인 방법 숙지

---

## 레벨 2: 중급 (Intermediate)

### 2.1 리버스 프록시 설정

**목표:** nginx를 프록시 서버로 활용

**디렉토리:** `examples/intermediate/01-reverse-proxy/`

```nginx
upstream backend {
    server app1:3000;
    server app2:3000;
}

server {
    listen 80;
    server_name localhost;
    
    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 2.2 로드 밸런싱

**목표:** 여러 서버에 트래픽 분산

**로드 밸런싱 방법:**
- `round-robin` (기본값)
- `least_conn` (최소 연결)
- `ip_hash` (IP 해시)
- `random` (랜덤)

```nginx
upstream backend {
    least_conn;  # 로드 밸런싱 방법
    server app1:3000 weight=3;
    server app2:3000 weight=1;
    server app3:3000 backup;  # 백업 서버
}
```

### 2.3 SSL/TLS 설정

**목표:** HTTPS 보안 연결 설정

**디렉토리:** `examples/intermediate/02-ssl/`

```nginx
server {
    listen 443 ssl http2;
    server_name localhost;
    
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}

# HTTP to HTTPS 리다이렉트
server {
    listen 80;
    server_name localhost;
    return 301 https://$server_name$request_uri;
}
```

### 2.4 정적 파일 캐싱

**목표:** 성능 향상을 위한 캐싱 설정

```nginx
server {
    listen 80;
    server_name localhost;
    
    # 이미지, CSS, JS 파일 캐싱
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        root /usr/share/nginx/html;
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
    
    # HTML 파일은 짧은 캐싱
    location ~* \.html$ {
        root /usr/share/nginx/html;
        expires 1h;
        add_header Cache-Control "public";
    }
}
```

### 2.5 압축 설정 (Gzip)

**목표:** 대역폭 절약을 위한 압축

```nginx
http {
    # Gzip 압축 설정
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;
        
    server {
        # ... 서버 설정
    }
}
```

### 2.6 레벨 2 체크리스트

- [ ] 리버스 프록시 설정 및 테스트
- [ ] 다양한 로드 밸런싱 방법 실습
- [ ] SSL/TLS 인증서 설정
- [ ] 정적 파일 캐싱 구현
- [ ] Gzip 압축 설정
- [ ] 프록시 헤더 설정 이해

---

## 레벨 3: 고급 (Advanced)

### 3.1 속도 제한 (Rate Limiting)

**목표:** DDoS 공격 방어 및 서버 보호

**디렉토리:** `examples/advanced/01-rate-limiting/`

```nginx
http {
    # Rate limit 영역 정의
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=login:10m rate=1r/s;
    
    server {
        listen 80;
        server_name localhost;
        
        # API 엔드포인트 속도 제한
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            proxy_pass http://backend;
        }
        
        # 로그인 엔드포인트 엄격한 제한
        location /login {
            limit_req zone=login burst=5;
            proxy_pass http://backend;
        }
    }
}
```

### 3.2 고급 캐싱 (Proxy Cache)

**목표:** 동적 콘텐츠 캐싱으로 성능 향상

```nginx
http {
    # 캐시 경로 설정
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m 
                     max_size=10g inactive=60m use_temp_path=off;
    
    server {
        listen 80;
        server_name localhost;
        
        location / {
            proxy_cache my_cache;
            proxy_cache_valid 200 302 10m;
            proxy_cache_valid 404 1m;
            proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
            proxy_cache_lock on;
            
            # 캐시 헤더 추가
            add_header X-Cache-Status $upstream_cache_status;
            
            proxy_pass http://backend;
        }
    }
}
```

### 3.3 로그 분석 및 모니터링

**목표:** 실시간 모니터링 및 로그 분석

```nginx
http {
    # 커스텀 로그 형식
    log_format custom '$remote_addr - $remote_user [$time_local] '
                     '"$request" $status $body_bytes_sent '
                     '"$http_referer" "$http_user_agent" '
                     '$request_time $upstream_response_time';
    
    server {
        listen 80;
        server_name localhost;
        
        access_log /var/log/nginx/access.log custom;
        error_log /var/log/nginx/error.log warn;
        
        # 상태 페이지 (모니터링용)
        location /nginx_status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            deny all;
        }
    }
}
```

### 3.4 보안 강화

**목표:** 고급 보안 설정

```nginx
http {
    # DDoS 방어
    limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
    limit_req_zone $binary_remote_addr zone=req_limit_per_ip:10m rate=5r/s;
    
    server {
        listen 80;
        server_name localhost;
        
        # 연결 수 제한
        limit_conn conn_limit_per_ip 20;
        limit_req zone=req_limit_per_ip burst=10 nodelay;
        
        # 보안 헤더
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
        add_header Content-Security-Policy "default-src 'self'" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header Referrer-Policy "strict-origin-when-cross-origin" always;
        
        # 악성 요청 차단
        location ~* \.(aspx|php|jsp|cgi)$ {
            return 404;
        }
        
        # 숨겨진 파일 접근 차단
        location ~ /\. {
            deny all;
            access_log off;
            log_not_found off;
        }
    }
}
```

### 3.5 마이크로서비스 아키텍처

**목표:** 마이크로서비스용 API 게이트웨이

**디렉토리:** `examples/advanced/02-microservices/`

```nginx
upstream auth_service {
    server auth:3001;
}

upstream user_service {
    server user:3002;
}

upstream order_service {
    server order:3003;
}

server {
    listen 80;
    server_name api.localhost;
    
    # 인증 서비스
    location /auth/ {
        proxy_pass http://auth_service/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # 사용자 서비스
    location /users/ {
        # 인증 확인
        auth_request /auth/verify;
        proxy_pass http://user_service/;
    }
    
    # 주문 서비스
    location /orders/ {
        auth_request /auth/verify;
        proxy_pass http://order_service/;
    }
    
    # 내부 인증 확인 엔드포인트
    location = /auth/verify {
        internal;
        proxy_pass http://auth_service/verify;
        proxy_pass_request_body off;
        proxy_set_header Content-Length "";
        proxy_set_header X-Original-URI $request_uri;
    }
}
```

### 3.6 레벨 3 체크리스트

- [ ] Rate Limiting 구현 및 테스트
- [ ] Proxy Cache 설정 및 효과 확인
- [ ] 고급 로그 분석 설정
- [ ] 보안 헤더 및 DDoS 방어 구현
- [ ] 마이크로서비스 API 게이트웨이 구축
- [ ] 모니터링 대시보드 설정

---

## 레벨 4: 전문가 (Expert)

### 4.1 커스텀 모듈 및 Lua 스크립팅

**목표:** nginx 기능 확장

**디렉토리:** `examples/expert/01-lua-scripting/`

```nginx
http {
    # Lua 스크립트 경로
    lua_package_path "/etc/nginx/lua/?.lua;;";
    
    server {
        listen 80;
        server_name localhost;
        
        # Lua를 이용한 동적 라우팅
        location /api/ {
            access_by_lua_block {
                local redis = require "resty.redis"
                local red = redis:new()
                red:set_timeout(1000)
                
                local ok, err = red:connect("redis", 6379)
                if not ok then
                    ngx.log(ngx.ERR, "failed to connect to redis: ", err)
                    return ngx.exit(500)
                end
                
                -- API 키 검증
                local api_key = ngx.var.http_x_api_key
                local res, err = red:get("api_key:" .. api_key)
                if not res or res == ngx.null then
                    ngx.log(ngx.ERR, "invalid api key: ", api_key)
                    return ngx.exit(401)
                end
            }
            
            proxy_pass http://backend;
        }
        
        # 동적 업스트림 선택
        location /smart-proxy/ {
            set $backend "";
            access_by_lua_block {
                -- 로드에 따른 동적 백엔드 선택
                local http = require "resty.http"
                local httpc = http.new()
                
                -- 백엔드 상태 확인
                local backends = {"backend1:3000", "backend2:3000", "backend3:3000"}
                for i, backend in ipairs(backends) do
                    local res, err = httpc:request_uri("http://" .. backend .. "/health")
                    if res and res.status == 200 then
                        ngx.var.backend = backend
                        break
                    end
                end
            }
            
            proxy_pass http://$backend;
        }
    }
}
```

### 4.2 성능 최적화 및 튜닝

**목표:** 최고 성능을 위한 세밀한 튜닝

```nginx
# nginx.conf 최적화
user nginx;
worker_processes auto;
worker_cpu_affinity auto;

events {
    worker_connections 4096;
    use epoll;
    multi_accept on;
    worker_aio_requests 32;
}

http {
    # 성능 최적화
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 30;
    keepalive_requests 1000;
    
    # 버퍼 크기 최적화
    client_body_buffer_size 128k;
    client_max_body_size 50m;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 4k;
    output_buffers 2 32k;
    postpone_output 1460;
    
    # 파일 캐시
    open_file_cache max=1000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
    
    # 커넥션 풀링
    upstream backend {
        server app1:3000;
        server app2:3000;
        keepalive 32;
        keepalive_requests 100;
        keepalive_timeout 60s;
    }
    
    server {
        listen 80 reuseport;
        server_name localhost;
        
        # HTTP/2 Server Push
        location = /index.html {
            root /usr/share/nginx/html;
            http2_push /css/main.css;
            http2_push /js/main.js;
        }
        
        location / {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Connection "";
        }
    }
}
```

### 4.3 고급 모니터링 및 알림

**목표:** 종합적인 모니터링 시스템

**디렉토리:** `examples/expert/02-monitoring/`

```nginx
http {
    # 메트릭 수집을 위한 로그 형식
    log_format metrics '$remote_addr $host $remote_user [$time_local] '
                      '"$request" $status $body_bytes_sent $request_time '
                      '$upstream_response_time "$http_user_agent" "$gzip_ratio"';
    
    # 실시간 메트릭 수집
    server {
        listen 9090;
        server_name metrics.localhost;
        
        location /metrics {
            access_log off;
            allow 127.0.0.1;
            allow 10.0.0.0/8;
            deny all;
            
            content_by_lua_block {
                local prometheus = require "resty.prometheus"
                prometheus:collect()
            }
        }
        
        location /health {
            access_log off;
            return 200 '{"status":"healthy","timestamp":"$time_iso8601"}';
            add_header Content-Type application/json;
        }
    }
    
    # 메인 서버
    server {
        listen 80;
        server_name localhost;
        
        access_log /var/log/nginx/metrics.log metrics;
        
        # 요청 메트릭 수집
        log_by_lua_block {
            local prometheus = require "resty.prometheus"
            prometheus:inc("nginx_requests_total", 1, {ngx.var.status, ngx.var.request_method})
            prometheus:histogram_observe("nginx_request_duration_seconds", ngx.var.request_time)
        }
        
        location / {
            proxy_pass http://backend;
        }
    }
}
```

### 4.4 블루-그린 배포

**목표:** 무중단 배포 시스템

```nginx
upstream blue {
    server app-blue-1:3000;
    server app-blue-2:3000;
}

upstream green {
    server app-green-1:3000;
    server app-green-2:3000;
}

map $cookie_deployment $pool {
    ~*green green;
    default blue;
}

server {
    listen 80;
    server_name localhost;
    
    # 배포 환경 전환
    location / {
        # 헬스체크 기반 자동 전환
        set $upstream blue;
        access_by_lua_block {
            local http = require "resty.http"
            local httpc = http.new()
            
            -- Green 환경 상태 확인
            local res, err = httpc:request_uri("http://app-green-1:3000/health")
            if res and res.status == 200 then
                local deployment = ngx.var.cookie_deployment or "blue"
                if deployment == "green" then
                    ngx.var.upstream = "green"
                end
            end
        }
        
        proxy_pass http://$upstream;
    }
    
    # 관리자용 배포 전환 엔드포인트
    location /admin/switch-deployment {
        access_by_lua_block {
            if ngx.var.remote_addr ~= "127.0.0.1" then
                return ngx.exit(403)
            end
        }
        
        content_by_lua_block {
            local target = ngx.var.arg_target
            if target == "blue" or target == "green" then
                ngx.header["Set-Cookie"] = "deployment=" .. target .. "; Path=/"
                ngx.say('{"status":"switched","target":"' .. target .. '"}')
            else
                ngx.status = 400
                ngx.say('{"error":"invalid target"}')
            end
        }
    }
}
```

### 4.5 전문가급 보안 설정

**목표:** 엔터프라이즈급 보안

```nginx
http {
    # WAF (Web Application Firewall) 규칙
    map $request_uri $blocked {
        ~*\.(asp|aspx|php)$ 1;
        ~*union.*select 1;
        ~*script.*alert 1;
        ~*\.\./\.\. 1;
        default 0;
    }
    
    # GeoIP 기반 차단
    geoip_country /usr/share/GeoIP/GeoIP.dat;
    map $geoip_country_code $allowed_country {
        default yes;
        CN no;
        RU no;
    }
    
    server {
        listen 443 ssl http2;
        server_name secure.localhost;
        
        # 고급 SSL 설정
        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;
        ssl_dhparam /etc/nginx/ssl/dhparam.pem;
        
        ssl_protocols TLSv1.3;
        ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
        ssl_prefer_server_ciphers off;
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        
        # HSTS
        add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
        
        # WAF 적용
        if ($blocked = 1) {
            return 403;
        }
        
        # 국가 기반 차단
        if ($allowed_country = no) {
            return 403;
        }
        
        location / {
            # 요청 검증
            access_by_lua_block {
                -- SQL 인젝션 패턴 검사
                local patterns = {
                    "union.*select",
                    "drop.*table",
                    "insert.*into",
                    "delete.*from"
                }
                
                local uri = ngx.var.request_uri:lower()
                for _, pattern in ipairs(patterns) do
                    if uri:match(pattern) then
                        ngx.log(ngx.ERR, "SQL injection attempt detected: ", ngx.var.request_uri)
                        return ngx.exit(403)
                    end
                end
            }
            
            proxy_pass http://backend;
        }
    }
}
```

### 4.6 레벨 4 체크리스트

- [ ] Lua 스크립팅을 이용한 동적 기능 구현
- [ ] 성능 최적화 및 벤치마킹
- [ ] 고급 모니터링 시스템 구축
- [ ] 블루-그린 배포 시스템 구현
- [ ] 엔터프라이즈급 보안 설정
- [ ] 고가용성 아키텍처 설계

---

## 참고 자료

### 공식 문서
- [nginx 공식 문서](https://nginx.org/en/docs/)
- [nginx 모듈 레퍼런스](https://nginx.org/en/docs/dirindex.html)

### 유용한 도구
- [nginx 설정 테스터](https://www.digitalocean.com/community/tools/nginx)
- [SSL 설정 검사](https://www.ssllabs.com/ssltest/)
- [nginx 성능 테스트](https://github.com/wg/wrk)

### 커뮤니티
- [nginx 공식 포럼](https://forum.nginx.org/)
- [Stack Overflow nginx 태그](https://stackoverflow.com/questions/tagged/nginx)

---

## 마치며

이 가이드를 통해 nginx의 기초부터 전문가 수준까지 체계적으로 학습할 수 있습니다. 각 레벨의 실습을 완료하면서 실무에서 활용할 수 있는 실력을 기를 수 있을 것입니다.

**다음 단계:**
1. 각 레벨의 실습을 순서대로 진행
2. 실무 프로젝트에 적용
3. 성능 모니터링 및 최적화
4. 보안 강화 및 운영 자동화

궁금한 점이 있으면 Issues를 통해 문의해주세요!