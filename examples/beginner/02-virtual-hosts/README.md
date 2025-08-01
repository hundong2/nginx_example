# Virtual Hosts (가상 호스트) 설정

이 예제는 하나의 nginx 서버로 여러 웹사이트를 호스팅하는 방법을 보여줍니다.

## 파일 구조
```
02-virtual-hosts/
├── nginx.conf          # nginx 설정 파일 (여러 server 블록)
├── docker-compose.yml  # Docker Compose 설정
├── site1/              # 첫 번째 사이트 콘텐츠
│   └── index.html
├── site2/              # 두 번째 사이트 콘텐츠
│   └── index.html
└── README.md          # 이 파일
```

## 실행 방법

1. 이 디렉토리로 이동:
   ```bash
   cd examples/beginner/02-virtual-hosts/
   ```

2. hosts 파일 수정 (로컬 테스트용):
   ```bash
   # Linux/Mac
   echo "127.0.0.1 site1.local" | sudo tee -a /etc/hosts
   echo "127.0.0.1 site2.local" | sudo tee -a /etc/hosts
   
   # Windows (관리자 권한으로 실행)
   # C:\Windows\System32\drivers\etc\hosts 파일에 추가:
   # 127.0.0.1 site1.local
   # 127.0.0.1 site2.local
   ```

3. Docker Compose로 실행:
   ```bash
   docker compose up -d
   ```

4. 브라우저에서 확인:
   - http://site1.local:8002
   - http://site2.local:8002
   - 또는 curl로 테스트:
     ```bash
     curl -H "Host: site1.local" http://localhost:8002
     curl -H "Host: site2.local" http://localhost:8002
     ```

5. 종료:
   ```bash
   docker compose down
   ```

## 학습 포인트

1. **Virtual Hosts 개념**
   - 하나의 서버로 여러 도메인 처리
   - `server_name` 지시어 활용
   - 각 사이트별 별도 설정 가능

2. **server_name 매칭**
   - 정확한 이름 매칭
   - 와일드카드 사용 (`*.example.com`)
   - 정규표현식 사용 (`~^(.+)\.example\.com$`)

3. **설정 분리**
   - 각 사이트별 로그 파일
   - 각 사이트별 에러 페이지
   - 각 사이트별 SSL 설정 (고급)

## 추가 실습

1. 세 번째 사이트 추가하기
2. 와일드카드 서브도메인 설정하기
3. 기본 서버 설정하기 (default_server)
4. 각 사이트별 다른 에러 페이지 설정하기