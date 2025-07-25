#!/bin/bash

# nginx 가이드 관리 스크립트
# 이 스크립트는 nginx 학습 환경을 쉽게 관리할 수 있도록 도와줍니다.

set -e

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 함수 정의
print_header() {
    echo -e "${BLUE}"
    echo "========================================"
    echo "🚀 nginx 완전 정복 가이드"
    echo "========================================"
    echo -e "${NC}"
}

print_usage() {
    echo "사용법: $0 [명령어]"
    echo ""
    echo "명령어:"
    echo "  start-guide      가이드 홈페이지만 실행 (포트 8000)"
    echo "  start-basic      기본 서버만 실행 (포트 8001)"
    echo "  start-virtual    Virtual Hosts만 실행 (포트 8002)"
    echo "  start-security   보안 헤더만 실행 (포트 8003)"
    echo "  start-all        모든 예제 실행"
    echo "  stop             모든 서비스 중지"
    echo "  status           실행 중인 서비스 상태 확인"
    echo "  logs             서비스 로그 확인"
    echo "  test             모든 엔드포인트 테스트"
    echo "  clean            모든 컨테이너 및 이미지 정리"
    echo "  help             이 도움말 표시"
    echo ""
    echo "예시:"
    echo "  $0 start-all     # 모든 nginx 예제 서비스 시작"
    echo "  $0 test          # 모든 서비스가 정상 작동하는지 테스트"
    echo "  $0 stop          # 모든 서비스 중지"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker가 설치되지 않았습니다.${NC}"
        exit 1
    fi
    
    if ! docker compose version &> /dev/null; then
        echo -e "${RED}❌ Docker Compose가 설치되지 않았습니다.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Docker 환경 확인 완료${NC}"
}

start_guide() {
    echo -e "${YELLOW}🏠 가이드 홈페이지를 시작합니다...${NC}"
    docker compose --profile guide up -d
    echo -e "${GREEN}✅ 가이드 홈페이지가 실행되었습니다!${NC}"
    echo -e "${BLUE}📱 브라우저에서 http://localhost:8000 을 확인하세요${NC}"
}

start_basic() {
    echo -e "${YELLOW}🌐 기본 웹 서버를 시작합니다...${NC}"
    docker compose --profile basic up -d
    echo -e "${GREEN}✅ 기본 웹 서버가 실행되었습니다!${NC}"
    echo -e "${BLUE}📱 브라우저에서 http://localhost:8001 을 확인하세요${NC}"
}

start_virtual() {
    echo -e "${YELLOW}🏠 Virtual Hosts를 시작합니다...${NC}"
    docker compose --profile virtual-hosts up -d
    echo -e "${GREEN}✅ Virtual Hosts가 실행되었습니다!${NC}"
    echo -e "${BLUE}📱 테스트 명령어:${NC}"
    echo "  curl -H \"Host: site1.local\" http://localhost:8002"
    echo "  curl -H \"Host: site2.local\" http://localhost:8002"
}

start_security() {
    echo -e "${YELLOW}🔒 보안 헤더 예제를 시작합니다...${NC}"
    docker compose --profile security up -d
    echo -e "${GREEN}✅ 보안 헤더 예제가 실행되었습니다!${NC}"
    echo -e "${BLUE}📱 브라우저에서 http://localhost:8003 을 확인하세요${NC}"
    echo -e "${BLUE}💻 보안 헤더 확인: curl -I http://localhost:8003${NC}"
}

start_all() {
    echo -e "${YELLOW}🚀 모든 nginx 예제를 시작합니다...${NC}"
    docker compose --profile all up -d
    echo -e "${GREEN}✅ 모든 서비스가 실행되었습니다!${NC}"
    echo -e "${BLUE}📱 접속 가능한 URL:${NC}"
    echo "  - 가이드 홈페이지: http://localhost:8000"
    echo "  - 기본 웹 서버: http://localhost:8001"
    echo "  - Virtual Hosts: http://localhost:8002 (Host 헤더 필요)"
    echo "  - 보안 헤더: http://localhost:8003"
}

stop_services() {
    echo -e "${YELLOW}🛑 모든 서비스를 중지합니다...${NC}"
    docker compose down
    echo -e "${GREEN}✅ 모든 서비스가 중지되었습니다!${NC}"
}

check_status() {
    echo -e "${BLUE}📊 서비스 상태 확인:${NC}"
    docker compose ps
    
    echo -e "\n${BLUE}🌐 포트 상태 확인:${NC}"
    local ports=(8000 8001 8002 8003)
    for port in "${ports[@]}"; do
        if curl -s -o /dev/null -w "" http://localhost:$port 2>/dev/null; then
            echo -e "  포트 $port: ${GREEN}✅ 실행 중${NC}"
        else
            echo -e "  포트 $port: ${RED}❌ 중지됨${NC}"
        fi
    done
}

show_logs() {
    echo -e "${BLUE}📋 서비스 로그:${NC}"
    docker compose logs --tail=50 -f
}

test_endpoints() {
    echo -e "${BLUE}🧪 엔드포인트 테스트 시작...${NC}"
    
    # 가이드 홈페이지 테스트
    if curl -s -o /dev/null -w "" http://localhost:8000; then
        echo -e "  가이드 홈페이지 (8000): ${GREEN}✅ 정상${NC}"
    else
        echo -e "  가이드 홈페이지 (8000): ${RED}❌ 실패${NC}"
    fi
    
    # 기본 서버 테스트
    if curl -s -o /dev/null -w "" http://localhost:8001; then
        echo -e "  기본 웹 서버 (8001): ${GREEN}✅ 정상${NC}"
    else
        echo -e "  기본 웹 서버 (8001): ${RED}❌ 실패${NC}"
    fi
    
    # Virtual Hosts 테스트
    if curl -s -o /dev/null -w "" -H "Host: site1.local" http://localhost:8002; then
        echo -e "  Virtual Host Site1 (8002): ${GREEN}✅ 정상${NC}"
    else
        echo -e "  Virtual Host Site1 (8002): ${RED}❌ 실패${NC}"
    fi
    
    if curl -s -o /dev/null -w "" -H "Host: site2.local" http://localhost:8002; then
        echo -e "  Virtual Host Site2 (8002): ${GREEN}✅ 정상${NC}"
    else
        echo -e "  Virtual Host Site2 (8002): ${RED}❌ 실패${NC}"
    fi
    
    # 보안 헤더 테스트
    if curl -s -o /dev/null -w "" http://localhost:8003; then
        echo -e "  보안 헤더 (8003): ${GREEN}✅ 정상${NC}"
        
        # 보안 헤더 확인
        if curl -s -I http://localhost:8003 | grep -q "X-Frame-Options"; then
            echo -e "    보안 헤더 설정: ${GREEN}✅ 확인됨${NC}"
        else
            echo -e "    보안 헤더 설정: ${YELLOW}⚠️ 일부 누락${NC}"
        fi
    else
        echo -e "  보안 헤더 (8003): ${RED}❌ 실패${NC}"
    fi
    
    echo -e "${GREEN}🎉 테스트 완료!${NC}"
}

clean_up() {
    echo -e "${YELLOW}🧹 정리 작업을 시작합니다...${NC}"
    
    # 서비스 중지
    docker compose down
    
    # 사용하지 않는 컨테이너 제거
    docker container prune -f
    
    # nginx 관련 이미지 제거 (선택사항)
    read -p "nginx 이미지도 제거하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker image prune -f
        echo -e "${GREEN}✅ 이미지 정리 완료${NC}"
    fi
    
    echo -e "${GREEN}✅ 정리 작업 완료!${NC}"
}

# 메인 로직
case "$1" in
    "start-guide")
        print_header
        check_docker
        start_guide
        ;;
    "start-basic")
        print_header
        check_docker
        start_basic
        ;;
    "start-virtual")
        print_header
        check_docker
        start_virtual
        ;;
    "start-security")
        print_header
        check_docker
        start_security
        ;;
    "start-all")
        print_header
        check_docker
        start_all
        ;;
    "stop")
        print_header
        stop_services
        ;;
    "status")
        print_header
        check_status
        ;;
    "logs")
        print_header
        show_logs
        ;;
    "test")
        print_header
        test_endpoints
        ;;
    "clean")
        print_header
        clean_up
        ;;
    "help"|"--help"|"-h")
        print_header
        print_usage
        ;;
    *)
        print_header
        echo -e "${RED}❌ 잘못된 명령어입니다.${NC}"
        echo ""
        print_usage
        exit 1
        ;;
esac