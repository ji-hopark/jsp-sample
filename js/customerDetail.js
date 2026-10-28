// customerDetail.jsp 전용: 고객 프로필과 연결 계좌 인쇄.
const printButton = document.getElementById('print-customer');
if (printButton) printButton.addEventListener('click', () => window.print());
