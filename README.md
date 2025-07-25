# 🚀 완전한 Nginx 가이드: 초보자에서 전문가까지

nginx를 처음 접하는 초보자부터 전문가 수준까지 단계별로 학습할 수 있는 종합 가이드입니다. 모든 예제는 Docker 환경에서 바로 실행할 수 있도록 구성되어 있습니다.

## 📋 목차

- [빠른 시작](#빠른-시작)
- [프로젝트 구조](#프로젝트-구조)
- [학습 레벨](#학습-레벨)
- [실행 방법](#실행-방법)
- [포트 정보](#포트-정보)

## 🚀 빠른 시작

```bash
# 저장소 클론
git clone https://github.com/hundong2/nginx_example.git
cd nginx_example

# 가이드 홈페이지 실행
docker compose --profile guide up -d

# 브라우저에서 http://localhost:8000 확인

# 모든 예제 실행
docker compose --profile all up -d
```

## 📁 프로젝트 구조

```
nginx_example/
├── nginx-guide.md              # 📖 완전한 가이드 문서
├── docker-compose.yml          # 🐳 메인 Docker Compose 파일
├── html/                       # 🏠 가이드 홈페이지
│   └── index.html
├── examples/                   # 📚 단계별 예제들
│   ├── beginner/              # 레벨 1: 기초
│   │   ├── 01-basic-server/   # 기본 웹 서버
│   │   └── 02-virtual-hosts/  # 가상 호스트
│   ├── intermediate/          # 레벨 2: 중급 (준비 중)
│   ├── advanced/              # 레벨 3: 고급 (준비 중)
│   └── expert/                # 레벨 4: 전문가 (준비 중)
├── nginx_config/              # 기존 설정 파일들
└── README.md                  # 이 파일
```

## 🎯 학습 레벨

### 📗 레벨 1: 기초 (Beginner)
- ✅ **기본 웹 서버 설정** - nginx의 기본 개념과 정적 파일 서빙
- ✅ **Virtual Hosts (가상 호스트)** - 하나의 서버로 여러 웹사이트 호스팅
- ✅ **기본 보안 헤더** - 웹사이트 보안을 위한 HTTP 보안 헤더 설정

### 📘 레벨 2: 중급 (Intermediate) - 준비 중
- 🔄 리버스 프록시 설정
- 🔄 로드 밸런싱
- 🔄 SSL/TLS 설정
- 🔄 캐싱 및 압축

### 📙 레벨 3: 고급 (Advanced) - 준비 중
- 🔄 Rate Limiting
- 🔄 고급 캐싱 전략
- 🔄 고급 보안 설정
- 🔄 로그 분석 및 모니터링

### 📕 레벨 4: 전문가 (Expert) - 준비 중
- 🔄 성능 최적화 및 튜닝
- 🔄 Lua 스크립팅
- 🔄 고급 모니터링 시스템
- 🔄 블루-그린 배포

## 🐳 실행 방법

### 전체 가이드 홈페이지
```bash
docker compose --profile guide up -d
# http://localhost:8000 접속
```

### 개별 예제 실행
```bash
# 기본 웹 서버
docker compose --profile basic up -d
# http://localhost:8001 접속

# Virtual Hosts
docker compose --profile virtual-hosts up -d
# Host 헤더로 테스트:
# curl -H "Host: site1.local" http://localhost:8002
# curl -H "Host: site2.local" http://localhost:8002

# 보안 헤더
docker compose --profile security up -d
# http://localhost:8003 접속
# curl -I http://localhost:8003 (헤더 확인)
```

### 모든 예제 실행
```bash
docker compose --profile all up -d
```

### 서비스 중지
```bash
docker compose down
```

## 🌐 포트 정보

| 포트 | 서비스 | 설명 |
|------|--------|------|
| 8000 | 가이드 홈페이지 | 전체 가이드 및 예제 링크 |
| 8001 | 기본 웹 서버 | nginx 기본 설정 예제 |
| 8002 | Virtual Hosts | 가상 호스트 예제 |
| 8003 | 보안 헤더 | HTTP 보안 헤더 예제 |

## 📖 상세 가이드

전체 가이드 문서는 [nginx-guide.md](./nginx-guide.md)를 참조하세요. 각 레벨별 상세한 설명과 실습 내용이 포함되어 있습니다.

## 🛠️ 기존 컨테이너 실행 (호환성)

기존 방식으로도 여전히 실행 가능합니다:

```bash
# 기존 방식
docker build -t my-nginx:latest .
./run-nginx.sh
```

## 🤝 기여하기

이 프로젝트에 기여하고 싶으시면:

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Submit a Pull Request

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다. 자세한 내용은 [LICENSE](./LICENSE) 파일을 참조하세요.

---

**🎯 목표:** nginx를 완전히 마스터하여 실무에서 자신 있게 활용할 수 있도록 돕는 것입니다!

궁금한 점이 있으면 Issues를 통해 언제든지 문의해주세요! 💬