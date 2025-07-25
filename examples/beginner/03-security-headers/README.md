# 기본 보안 헤더 설정

이 예제는 nginx에서 기본적인 보안 헤더를 설정하여 웹사이트 보안을 강화하는 방법을 보여줍니다.

## 파일 구조
```
03-security-headers/
├── nginx.conf          # 보안 헤더가 포함된 nginx 설정
├── docker-compose.yml  # Docker Compose 설정
├── html/              # 웹 콘텐츠
│   ├── index.html     # 보안 헤더 정보를 보여주는 페이지
│   └── test.html      # 보안 테스트 페이지
└── README.md          # 이 파일
```

## 실행 방법

1. 이 디렉토리로 이동:
   ```bash
   cd examples/beginner/03-security-headers/
   ```

2. Docker Compose로 실행:
   ```bash
   docker compose up -d
   ```

3. 브라우저에서 확인:
   - http://localhost:8003

4. 보안 헤더 확인:
   ```bash
   curl -I http://localhost:8003
   ```

5. 종료:
   ```bash
   docker compose down
   ```

## 학습 포인트

### 1. 기본 보안 헤더들

- **X-Frame-Options**: 클릭재킹 공격 방지
- **X-Content-Type-Options**: MIME 타입 스니핑 방지
- **X-XSS-Protection**: XSS 공격 방지 (구식 브라우저용)
- **Referrer-Policy**: 리퍼러 정보 제어
- **Content-Security-Policy**: 콘텐츠 보안 정책

### 2. nginx 보안 설정

- **server_tokens off**: nginx 버전 정보 숨기기
- **client_max_body_size**: 업로드 파일 크기 제한
- **숨겨진 파일 접근 차단**: .htaccess, .git 등

### 3. 보안 테스트

- 브라우저 개발자 도구에서 헤더 확인
- 온라인 보안 스캐너 활용
- curl 명령어로 헤더 검증

## 추가 실습

1. CSP(Content Security Policy) 강화하기
2. HSTS(HTTP Strict Transport Security) 설정하기
3. 특정 파일 접근 차단하기
4. 보안 헤더 온라인 테스트하기