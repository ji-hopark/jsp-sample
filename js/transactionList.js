import { downloadCsv } from './common.js';

// transactionList.jsp 전용: 날짜 검증과 현재 조회 결과 내보내기.
const form = document.getElementById('transaction-form');
const from = document.getElementById('from');
const to = document.getElementById('to');
function validateDates() {
    const invalid = from.value && to.value && from.value > to.value;
    to.setCustomValidity(invalid ? '종료일은 시작일 이후로 선택해 주세요.' : '');
}
from.addEventListener('input', validateDates);
to.addEventListener('input', validateDates);
form.addEventListener('submit', event => {
    validateDates();
    if (!form.reportValidity()) event.preventDefault();
});
document.getElementById('export-transactions').addEventListener('click', () => {
    const rows = [...document.querySelectorAll('table tr')].map(row =>
        [...row.cells].map(cell => cell.innerText.replace(/\n/g, ' '))
    );
    downloadCsv('sample-transactions.csv', rows);
});
