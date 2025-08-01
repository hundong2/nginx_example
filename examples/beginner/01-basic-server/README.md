# 기본 웹 서버 설정

이 예제는 nginx의 가장 기본적인 웹 서버 설정을 보여줍니다.

## 파일 구조
```
01-basic-server/
├── nginx.conf          # nginx 설정 파일
├── docker-compose.yml  # Docker Compose 설정
├── html/              # 웹 콘텐츠
│   ├── index.html
│   ├── about.html
│   └── css/
│       └── style.css
└── README.md          # 이 파일
```

## 실행 방법

1. 이 디렉토리로 이동:
   ```bash
   cd examples/beginner/01-basic-server/
   ```

2. Docker Compose로 실행:
   ```bash
   docker-compose up -d
   ```

3. 브라우저에서 확인:
   - http://localhost:8001

4. 로그 확인:
   ```bash
   docker-compose logs -f nginx
   ```

5. 종료:
   ```bash
   docker-compose down
   ```

## 학습 포인트

1. **기본 nginx.conf 구조**
   - `events` 블록: 연결 처리 설정
   - `http` 블록: HTTP 관련 설정
   - `server` 블록: 가상 호스트 설정

2. **정적 파일 서빙**
   - `root` 지시어: 문서 루트 설정
   - `index` 지시어: 기본 파일 설정

3. **기본 보안**
   - 서버 토큰 숨기기
   - 기본 에러 페이지

## 추가 실습

1. 다른 포트로 변경해보기
2. 다른 HTML 파일 추가하기
3. CSS/JS 파일 추가하기
4. 에러 페이지 커스터마이징하기