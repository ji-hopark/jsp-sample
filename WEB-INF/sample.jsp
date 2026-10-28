<%@ page pageEncoding="UTF-8" import="java.util.*,java.time.LocalDate,java.text.NumberFormat" %>
<%!
    // JSP 전용 읽기 샘플. 실제 JEX/DB 연동 시 이 데이터 공급 부분을 교체합니다.
    private static class Account {
        final String id, number, owner, product, status, opened;
        final long balance;
        Account(String id, String number, String owner, String product, String status, long balance, String opened) {
            this.id=id; this.number=number; this.owner=owner; this.product=product;
            this.status=status; this.balance=balance; this.opened=opened;
        }
    }
    private static class Entry {
        final String date, accountId, name, type;
        final long amount, balance;
        Entry(String date, String accountId, String name, String type, long amount, long balance) {
            this.date=date; this.accountId=accountId; this.name=name; this.type=type;
            this.amount=amount; this.balance=balance;
        }
    }
    private List<Account> accounts() {
        return Arrays.asList(
            new Account("A001", "110-000-000001", "김민준", "입출금통장", "정상", 12580000L, "2024-03-12"),
            new Account("A002", "110-000-000002", "이서연", "급여통장", "정상", 8240000L, "2024-05-08"),
            new Account("A003", "110-000-000003", "박지호", "자유적금", "정상", 18000000L, "2023-11-21"),
            new Account("A004", "110-000-000004", "최수빈", "입출금통장", "거래중지", 350000L, "2022-09-16"),
            new Account("A005", "110-000-000005", "정도윤", "정기예금", "정상", 30000000L, "2025-01-03"),
            new Account("A006", "110-000-000006", "한유진", "입출금통장", "해지", 0L, "2021-07-19")
        );
    }
    private List<Entry> entries() {
        return Arrays.asList(
            new Entry("2026-10-28", "A001", "10월 급여", "입금", 3500000L, 12580000L),
            new Entry("2026-10-28", "A002", "온라인 쇼핑", "출금", 76000L, 8240000L),
            new Entry("2026-10-27", "A003", "자동이체 적립", "입금", 500000L, 18000000L),
            new Entry("2026-10-27", "A001", "관리비", "출금", 180000L, 9080000L),
            new Entry("2026-10-26", "A005", "예금 가입", "입금", 30000000L, 30000000L),
            new Entry("2026-10-25", "A002", "10월 급여", "입금", 3200000L, 8316000L),
            new Entry("2026-10-24", "A001", "카드대금", "출금", 420000L, 9260000L),
            new Entry("2026-10-23", "A004", "생활비", "출금", 150000L, 350000L),
            new Entry("2026-10-22", "A002", "통신요금", "출금", 65000L, 5116000L),
            new Entry("2026-10-21", "A003", "추가 적립", "입금", 1000000L, 17500000L),
            new Entry("2026-10-20", "A001", "교통비", "출금", 32000L, 9680000L),
            new Entry("2026-10-19", "A002", "환급금", "입금", 120000L, 5181000L)
        );
    }
    private static class Customer {
        final String id, accountId, name, tier, phone, email, joined, manager, state;
        Customer(String id, String accountId, String name, String tier, String phone, String email, String joined, String manager, String state) {
            this.id=id; this.accountId=accountId; this.name=name; this.tier=tier; this.phone=phone;
            this.email=email; this.joined=joined; this.manager=manager; this.state=state;
        }
    }
    private List<Customer> customers() {
        List<Customer> result=new ArrayList<Customer>();
        int index=0;
        for (Account account : accounts()) {
            index++;
            String tier=index==5 ? "프리미엄" : index==1 || index==3 ? "우수" : "일반";
            String state="정상".equals(account.status) ? "정상" : "해지".equals(account.status) ? "휴면" : "확인필요";
            result.add(new Customer("C00"+index, account.id, account.owner, tier, "010-****-000"+index,
                "sample"+index+"@example.com", account.opened, index%2==0 ? "이담당" : "김관리", state));
        }
        return result;
    }
    private Customer findCustomer(String id) {
        for (Customer customer : customers()) if (customer.id.equals(id)) return customer;
        return null;
    }
    private Customer customerForAccount(String id) {
        for (Customer customer : customers()) if (customer.accountId.equals(id)) return customer;
        return null;
    }
    private static class Transfer {
        final String id, date, accountId, recipient, bank, destination, status, memo;
        final long amount;
        Transfer(String id, String date, String accountId, String recipient, String bank, String destination, long amount, String status, String memo) {
            this.id=id; this.date=date; this.accountId=accountId; this.recipient=recipient; this.bank=bank;
            this.destination=destination; this.amount=amount; this.status=status; this.memo=memo;
        }
    }
    private List<Transfer> transfers() {
        return Arrays.asList(
            new Transfer("T006", "2026-10-30", "A002", "이하늘", "NOVA", "110-***-900006", 100000L, "예약", "모임 회비 · 예약 이체 예제"),
            new Transfer("T005", "2026-10-29", "A001", "이다은", "샘플은행", "220-***-900005", 650000L, "예약", "11월 월세 · 예약 이체 예제"),
            new Transfer("T004", "2026-10-28", "A002", "김서준", "샘플은행", "220-***-900004", 50000L, "실패", "받는 계좌 확인 불가 · 실패 상태 예제"),
            new Transfer("T003", "2026-10-28", "A002", "샘플스토어", "NOVA", "110-***-900003", 76000L, "완료", "온라인 쇼핑"),
            new Transfer("T002", "2026-10-27", "A001", "샘플관리사무소", "샘플은행", "220-***-900002", 180000L, "완료", "관리비"),
            new Transfer("T001", "2026-10-23", "A004", "최수빈", "NOVA", "110-***-900001", 150000L, "완료", "생활비")
        );
    }
    private static class Notice {
        final String id, date, category, title, body, href, linkText;
        Notice(String id, String date, String category, String title, String body, String href, String linkText) {
            this.id=id; this.date=date; this.category=category; this.title=title;
            this.body=body; this.href=href; this.linkText=linkText;
        }
    }
    private List<Notice> notices() {
        return Arrays.asList(
            new Notice("N006", "2026-10-28", "중요", "이체 실패 내역을 확인해 주세요", "김서준 님에게 보내는 이체 1건이 실패한 예제입니다. 이체 내역에서 상세 사유를 확인할 수 있습니다.", "transferList.jsp?status=실패", "실패 이체 확인"),
            new Notice("N005", "2026-10-28", "중요", "고객 정보 확인이 필요합니다", "최수빈 고객은 확인필요 상태입니다. 고객 상세에서 연결 계좌와 기본 정보를 확인해 주세요.", "customerDetail.jsp?id=C004", "고객 정보 확인"),
            new Notice("N004", "2026-10-27", "안내", "10월 거래 내역 조회 안내", "이번 달 계좌별 입출금 내역을 조회하고, 조회한 결과를 CSV 파일로 내려받을 수 있습니다.", "transactionList.jsp", "거래 내역 보기"),
            new Notice("N003", "2026-10-26", "점검", "샘플 정기 점검 안내", "2026.11.01 02:00–04:00 점검 공지를 표현한 가상 예제입니다. 실제 서비스 점검 일정이 아닙니다.", "", ""),
            new Notice("N002", "2026-10-25", "안내", "예약 이체 현황을 확인하세요", "현재 가상 예약 이체는 2건입니다. 예약일과 받는 분, 금액을 이체 내역에서 확인해 주세요.", "transferList.jsp?status=예약", "예약 이체 보기"),
            new Notice("N001", "2026-10-24", "안내", "고객 관리 화면이 추가되었습니다", "고객 등급, 담당자와 연결 계좌를 한곳에서 확인할 수 있습니다. 표시된 고객 정보는 모두 가상 정보입니다.", "customerList.jsp", "고객 관리 열기")
        );
    }
    private Account findAccount(String id) {
        for (Account account : accounts()) if (account.id.equals(id)) return account;
        return null;
    }
    private String h(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            .replace("\"", "&quot;").replace("'", "&#39;");
    }
    private String money(long value) { return NumberFormat.getIntegerInstance(Locale.KOREA).format(value); }
    private String badge(String status) {
        return "정상".equals(status) ? "good" : "거래중지".equals(status) ? "warn" : "neutral";
    }
    private String json(String value) {
        StringBuilder escaped = new StringBuilder("\"");
        for (char c : value.toCharArray()) {
            switch (c) {
                case '"': escaped.append("\\\""); break;
                case '\\': escaped.append("\\\\"); break;
                case '\n': escaped.append("\\n"); break;
                case '\r': escaped.append("\\r"); break;
                case '\t': escaped.append("\\t"); break;
                default:
                    if (c < 32) escaped.append(String.format("\\u%04x", (int)c));
                    else escaped.append(c);
            }
        }
        return escaped.append('"').toString();
    }
%>
