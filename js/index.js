import { downloadCsv } from './common.js';

// index.jsp 전용: 대시보드에 표시된 계좌 잔액 내보내기.
document.getElementById('export-overview').addEventListener('click', () => {
    const rows = [['예금주', '계좌번호', '잔액(원)']];
    for (const column of document.querySelectorAll('.chart-col')) {
        rows.push([column.dataset.owner, column.dataset.number, column.dataset.balance]);
    }
    downloadCsv('sample-account-balances.csv', rows);
});
