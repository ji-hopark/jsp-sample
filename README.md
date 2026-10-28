# NOVA Business JSP 샘플

가상 고객·계좌·거래 데이터로 동작하는 금융 업무 화면 샘플입니다. 화면 JSP마다 같은 이름의 JavaScript 파일을 연결했습니다. 별도 Java 서비스 소스, JEX 라이브러리, Oracle DB 없이 실행됩니다.

## 실행

Docker와 Docker Compose가 설치된 환경에서 실행합니다.

```sh
docker compose up -d
```

[http://localhost:18080](http://localhost:18080)에서 확인할 수 있습니다. 최초 실행 시 Tomcat 이미지를 내려받습니다. JSP를 파일로 직접 열거나 정적 HTTP 서버로 제공하면 실행되지 않습니다.

```sh
# 로그 확인
docker compose logs -f jsp

# 종료
docker compose down
```

실행 환경은 Tomcat 9 / JDK 21입니다. 소스는 읽기 전용 볼륨으로 연결되며 수정 후 브라우저를 새로고침하면 반영됩니다. JSP 변경은 서버의 재컴파일 확인 주기에 따라 잠시 지연될 수 있습니다. 포트는 로컬 호스트에만 공개됩니다.

## 화면과 JavaScript 매핑

| 화면 | 화면 JSP | 전용 JS | 주요 기능 |
| --- | --- | --- | --- |
| 대시보드 | `index.jsp` | `js/index.js` | 계좌 요약, 잔액 차트, 잔액 CSV 다운로드 |
| 계좌 목록 | `accountList.jsp` | `js/accountList.js` | AJAX 검색, 계좌 상태 필터, 상세 이동 |
| 계좌 상세 | `accountDetail.jsp` | `js/accountDetail.js` | 계좌번호 복사, 고객·거래 화면 연결 |
| 거래 내역 | `transactionList.jsp` | `js/transactionList.js` | 계좌·기간·입출금 조회, 날짜 검증, CSV 다운로드 |
| 고객 목록 | `customerList.jsp` | `js/customerList.js` | AJAX 검색, 고객 등급·상태 필터 |
| 고객 상세 | `customerDetail.jsp` | `js/customerDetail.js` | 프로필, 연결 계좌, 고객 정보 인쇄 |
| 이체 내역 | `transferList.jsp` | `js/transferList.js` | AJAX 검색, 계좌·상태 필터, 실패 사유 확인 |
| 업무 알림 | `notificationList.jsp` | `js/notificationList.js` | AJAX 검색, 분류·읽음 필터, 관련 업무 이동 |

고객·계좌 상세는 목록에서 선택해 접근합니다. 예: `customerDetail.jsp?id=C001`, `accountDetail.jsp?id=A001`.

## 요청 흐름

```text
accountList.jsp
  → js/accountList.js
  → fetch / AJAX
  → accountListAction.jsp
  → JSON 응답
  → 계좌 목록 갱신
```

같은 방식으로 `customerListAction.jsp`, `transferListAction.jsp`, `notificationListAction.jsp`가 각각 JSON 조회 요청을 처리합니다. 처리 JSP는 브라우저 화면이 아니므로 전용 JS를 연결하지 않습니다. 대시보드·상세·거래 내역의 초기 데이터는 화면 JSP에서 렌더링합니다.

공통 코드는 다음 위치에 있습니다.

- `WEB-INF/sample.jsp`: 가상 데이터, 조회 함수, HTML·JSON 이스케이프 함수
- `WEB-INF/header.jsp`, `WEB-INF/footer.jsp`: 공통 레이아웃과 메뉴
- `js/common.js`: DOM 생성, AJAX 조회, CSV 다운로드 공통 함수
- `css/common.css`: 화면, 반응형, 인쇄 스타일

`WEB-INF` 파일은 브라우저에서 직접 접근할 수 없습니다. 실제 JEX/DB 연결이 필요하면 처리 JSP의 데이터 조회 부분을 교체할 수 있습니다.

## 샘플 데이터

- 표시 기준일: 2026-10-28
- 고객 6명, 계좌 6개, 표본 거래 12건, 이체 6건, 알림 6건
- 예약 이체는 표시 기준일 이후의 가상 일정입니다.
- 모든 계좌·고객·연락처·공지·금액은 예제이며 실제 금융 거래나 고객 정보 변경을 실행하지 않습니다.
- 알림 읽음 상태는 현재 브라우저 탭의 `sessionStorage`에 저장합니다. 서버에는 저장하지 않습니다.

## 확인한 동작

Tomcat에서 8개 JSP와 대응 JS의 HTTP 응답, JSON 조회·입력 검증·오류 응답을 확인했습니다. 브라우저에서 한글 검색, 상태·등급 필터, 고객·계좌·거래 간 이동, 계좌번호 복사, CSV 다운로드, 알림 읽음 상태 유지, 날짜 검증, 390px 너비에서의 화면 배치를 확인했습니다.
