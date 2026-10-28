import { element, badge, link, tableMessage, setupSearch } from './common.js';

// transferList.jsp 전용: 이체 내역 AJAX 조회와 상태별 요약.
const body = document.getElementById('transfer-rows');
const count = document.getElementById('transfer-count');
const format = new Intl.NumberFormat('ko-KR');
const summary = (amount, scheduled, failed) => {
    document.getElementById('transfer-amount').textContent = amount;
    document.getElementById('transfer-scheduled').textContent = scheduled;
    document.getElementById('transfer-failed').textContent = failed;
};
setupSearch({
    form: document.getElementById('transfer-form'), endpoint: 'transferListAction.jsp',
    container: body, count,
    render(data) {
        body.replaceChildren();
        let amount = 0, scheduled = 0, failed = 0;
        for (const transfer of data.transfers) {
            if (transfer.status === '완료') amount += transfer.amount;
            if (transfer.status === '예약') scheduled++;
            if (transfer.status === '실패') failed++;
            const row = element('tr');
            const date = element('td', transfer.date, 'mono');
            date.append(element('div', transfer.id, 'secondary'));
            const account = element('td');
            account.append(link(transfer.owner, 'accountDetail.jsp?id=' + encodeURIComponent(transfer.accountId)), element('div', transfer.number, 'secondary mono'));
            const recipient = element('td', transfer.recipient);
            recipient.append(element('div', transfer.bank + ' · ' + transfer.destination, 'secondary mono'));
            const status = element('td'); status.append(badge(transfer.status));
            const detail = element('td');
            const disclosure = element('details', '', 'transfer-detail');
            const toggle = element('summary', '상세 보기');
            toggle.setAttribute('aria-label', transfer.id + ' 이체 상세 보기');
            disclosure.append(toggle, element('p', transfer.memo));
            detail.append(disclosure);
            row.append(date, account, recipient, element('td', format.format(transfer.amount) + '원', 'numeric'), status, detail);
            body.append(row);
        }
        if (!data.transfers.length) tableMessage(body, '조회 조건에 맞는 이체 내역이 없습니다.', 6);
        summary(format.format(amount), scheduled, failed);
        count.textContent = '총 ' + data.transfers.length + '건의 이체';
    },
    error(message) { tableMessage(body, message, 6); summary('—', '—', '—'); }
});
