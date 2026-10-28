// accountList.jsp 전용: AJAX 조회와 검색 결과 렌더링.
(() => {
    const form = document.getElementById('search-form');
    const rows = document.getElementById('account-rows');
    const count = document.getElementById('result-count');
    const format = new Intl.NumberFormat('ko-KR');
    let controller;
    const cell = (text, className = '') => {
        const td = document.createElement('td');
        td.textContent = text;
        td.className = className;
        return td;
    };
    const message = text => {
        const row = document.createElement('tr');
        const td = cell(text, 'empty');
        td.colSpan = 6;
        row.append(td);
        rows.replaceChildren(row);
    };
    async function load() {
        if (controller) controller.abort();
        const current = new AbortController();
        controller = current;
        rows.setAttribute('aria-busy', 'true');
        message('계좌를 불러오는 중입니다.');
        count.textContent = '조회 중';
        const params = new URLSearchParams(new FormData(form));
        try {
            const response = await fetch('accountListAction.jsp?' + params, { signal: current.signal, headers: { Accept: 'application/json' } });
            if (!response.ok) throw new Error('조회 실패');
            const data = await response.json();
            if (controller !== current) return;
            const result = document.createDocumentFragment();
            for (const account of data.accounts) {
                const row = document.createElement('tr');
                row.append(cell(account.number, 'mono'), cell(account.owner), cell(account.product));
                const status = cell('');
                const badge = document.createElement('span');
                badge.className = 'badge ' + (account.status === '정상' ? 'good' : account.status === '거래중지' ? 'warn' : 'neutral');
                badge.textContent = account.status;
                status.append(badge);
                const detail = cell('');
                const link = document.createElement('a');
                link.href = 'accountDetail.jsp?id=' + encodeURIComponent(account.id);
                link.className = 'text-link';
                link.textContent = '상세 보기 →';
                link.setAttribute('aria-label', account.owner + ' 계좌 상세 보기');
                detail.append(link);
                row.append(status, cell(format.format(account.balance) + '원', 'numeric'), detail);
                result.append(row);
            }
            rows.replaceChildren(result);
            if (!data.accounts.length) message('검색 조건에 맞는 계좌가 없습니다.');
            count.textContent = '총 ' + data.accounts.length + '개의 계좌';
        } catch (error) {
            if (error.name !== 'AbortError' && controller === current) {
                message('계좌를 불러오지 못했습니다. 계좌 조회 버튼을 눌러 다시 시도해 주세요.');
                count.textContent = '조회 실패';
            }
        } finally {
            if (controller === current) rows.setAttribute('aria-busy', 'false');
        }
    }
    form.addEventListener('submit', event => { event.preventDefault(); load(); });
    form.addEventListener('reset', event => {
        event.preventDefault();
        form.elements.keyword.value = '';
        form.elements.status.value = '';
        load();
    });
    load();
})();
